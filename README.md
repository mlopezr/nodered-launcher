# Node-RED Docker launcher

This is a quick and dirty shell script that can launch many Node-RED docker containers behind an nginx reverse proxy with data in a Docker volume and a different password for each one.

# Run

First, you must have a DNS alias that will forward \*.subdomain.yourdomain.com to your machine

Then, run nginx proxy so that it will proxy all containers with an env var `VIRTUAL_HOST=subdomain.youdomain.com`:

```
docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
```

Make sure you have build the docker image within nodered-docker-pwdgenerator
Finally, launch as many instances 

```
./launchNodeREDinstance.sh username
This script will create a Docker instance named nodered-username with its data stored in nodered_data_username
Type password for account admin and press ENTER:
73932c9eb6610d6ee9b40094724ee99b5626e57715ef25fc822415d9200a1694
You should now be able to login to the new Node-RED instance at http://username.subdomain.youdomain.com
```

