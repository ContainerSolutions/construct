# Construct
Run one app/framework on each mesos agent. Useful in 'helper' use cases. E.g. installing a networking helper, a load balancer helper, or some application specific requirements.

## Requirements
- Python 2.7
- `pip install -r requirements.txt`
- MiniMesos.org (preferred)
- Vagrant (if you don't want to use mini-mesos).

## Running
Run `python launch.py`. It will install a simple webserver on every slave.

## OSX
Note that the `pip install` stage will not work with OSX's native python2. Install python2 from Homebrew:
`brew install python`
then execute
`sudo pip install -r requirements.txt`
