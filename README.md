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
  on the command line. (On most machines, this seems to be `192.168.59.103`).
* On OS X, visit `http://192.168.59.103:5000` (or the equivalent result of `boot2docker ip`) in your
  browser to see the application running.

## Installation without Docker

1) Install Postgres database (OS X):

`$ brew install postgresql`

2) Start postgres (Ctrl+C to quit):

`$ postgres -D /usr/local/var/postgres`

3) Create database 'actionite_db':

`$ psql template1`

`template1=# CREATE DATABASE actionite_db;`

4) You need to find out these values of your db to fill in the .env file:
- username (probably your computer's username)
- password (if there's any, probably not)
- host (probably '127.0.0.1')
- port (probably '5432')
- db_name (we know that! -> 'actionite_db')

5) You can run this to find out info about your db engine:

`$ psql --help`

Now, inside the project's folder:

1) (This will install gemset and dep gems, and start a shell)

`$ make gems`

2) (This will install the project's gems -named in .gems file-)

`$ make install`

3 (This will create the table 'campaigners' in the 'actionite_db' db)

`$ make db`

4) (This will start the server)

`$ make server`

Done!

Members homepage
http://localhost:9393

Actionite homepage
http://localhost:9393/actionite
