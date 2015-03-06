# Actionite
SumOfUs Experiment with ActionKit in ruby.

## Installation

* If you're using OS X, install Docker and Boot2Docker together via homebrew: `brew install boot2docker`
* If you're using a Linux variant, you can install Docker natively via: `sudo apt-get install docker` or
  similar for RH-based systems.
* Follow the instructions for installing Docker-Compose [here](http://docs.docker.com/compose/install/)
* Clone the project to your local system using git (this is left as an exercise for the reader).
* `docker-compose build` This will take a few minutes to download the relevant containers and install
  ruby gems.
* `docker-compose up` This will start the application running in the docker container.
* If you are on Linux, you can check that the application is running by visiting `http://localhost:5000`.
* If you are on OS X, you will need to retrieve the IP of your Docker vm by running `boot2docker ip`
  on the command line. (On most machines, this seems to be `192.168.59.3`).
* On OS X, visit `http://192.168.59.3:5000` (or the equivalent result of `boot2docker ip`) in your
  browser to see the application running.

