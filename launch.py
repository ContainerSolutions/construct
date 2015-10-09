import random
from time import sleep
import pprint

import requests

from construct import ApiConnector, get_json


pretty = pprint.PrettyPrinter(indent=2)

API_V1 = '/api/v1/scheduler'
DOCKER_JSON = "./resources/container.json"
LAUNCH_JSON = "./resources/launch.json"
TASK_RESOURCES_JSON = "./resources/task_resources.json"

class Launcher:
    def __init__(self, master_url):
        self.conn = None
        self.background_thread = None
        self.master_url = master_url
        self.api_url = '{}/{}'.format(master_url, API_V1)

    def connect(self):
        r = requests.get("{}/state.json".format(self.master_url))
        self.conn = ApiConnector(self.master_url)
        self.background_thread = self.conn.register_framework()

    def wait_for_offers(self):
        count = 0
        while not self.conn.framework_id and count < 10:
            sleep(3)
            print('.')
            count += 1

        if not self.conn.framework_id:
            print("Failed to register, terminating Framework")
            self.conn.close_channel()
        else:
            count = 0
            while not self.conn.offers and count < 10:
                print('.')
                sleep(3)
                count += 1

            if not self.conn.offers:
                print("Failed to obtain resources, terminating Framework")
                self.conn.terminate_framework(self.conn.framework_id)
                self.conn.close_channel()
            else:
                print("Got offers:")
                pretty.pprint(self.conn.offers)

    def launch(self):
        my_offers = self.conn.offers.get('offers')
        for i in range(0, len(my_offers)):
            print("Starting offer ", i + 1, " of ", len(my_offers))
            offer = my_offers[i]
            launch_json = get_json(LAUNCH_JSON)

            task_id = str(random.randint(100, 1000))

            launch_json["accept"]["offer_ids"].append(offer["id"])
            launch_json["framework_id"]["value"] = self.conn.framework_id

            task_infos = launch_json["accept"]["operations"][0]["launch"]["task_infos"][0]

            task_infos["task_id"]["value"] = task_id
            task_infos["command"]["value"] = "/usr/bin/python -m SimpleHTTPServer 9000"
            task_infos["agent_id"]["value"] = offer["agent_id"]["value"]
            task_infos["resources"] = get_json(TASK_RESOURCES_JSON)


            try:
                r = self.conn.post(self.api_url, launch_json)
                print("Result: {}".format(r.status_code))
                if r.text:
                    print(r.text)
                if 200 <= r.status_code < 300:
                    print("Successfully launched task {} on Agent [{}]".format(task_id, self.conn.offers.get('offers')[0]["agent_id"]["value"]))
            except ValueError, err:
                print("Request failed: {}".format(err))


def main():
    launcher = Launcher("http://172.17.0.31:5050")
    launcher.connect()
    launcher.wait_for_offers()
    launcher.launch()
    launcher.background_thread.join()

if __name__ == '__main__':
    main()
