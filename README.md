# Speedtestplusplus

A easy to setup speedtest worker for speedtest.net based on speedtestplusplus (https://github.com/taganaka/SpeedTest). 

As this supports raw tcp it can act as *a more precise replacement* for the "standard" speedtest.net collector https://hub.docker.com/r/atribe/speedtest-for-influxdb-and-grafana/

Be nice, this is my first repo.


# Installation instructions
## Pull and Build the image - optional (as you may pull this image from dockerhub too)
`git clone https://github.com/valki2/Speedtestplusplus`

then enter the created repo and build your image

`cd Speedtestplusplus`

`docker build --tag="valki:speedtestplusplus" .`


## Set up your docker network
To tangle everything together please create a network for your containers called speedtestnet. You can click through a tool like portainer or just use the docker command somehow like this:
```
docker network create --driver=bridge --subnet=	172.29.99.0/22 --ip-range=172.29.99.0/25 --gateway=172.29.99.1 
  ```
    
## Fire up the docker containers
First we need an influxdb container... or feel free to use your own instead!

`docker run --name influxdb --hostname influxdb --net speedtestnet  -d --restart always -e INFLUXDB_ADMIN_USER=admin -e INFLUXDB_ADMIN_PASSWORD=password -e INFLUXDB_DB=speedtest -v speedtest_influxdb:/var/lib/influxdb influxdb:1.5`

Then you may want a grafana instance for your funny little trees eeeh dashboard...

`docker run --name grafana  --hostname grafana  --net speedtestnet -d --restart always -p 3000:3000 -v speedtest_grafana:/etc/grafana/provisioning -v grafana-storage:/var/lib/grafana -e GF_SERVER_ROOT_URL=http://localhost -e GF_SECURITY_ADMIN_PASSWORD=admin -e GF_AUTH_ANONYMOUS_ENABLED=true grafana/grafana:latest`

Finally fire up your speedtestplusplus worker container

`docker run -d --name=speedtest --net speedtestnet -d --restart always  -e SPEEDTEST_INTERVAL=600 -e SPEEDTEST_HOST=local  valki:speedtestplusplus`

##Configure Grafana Dashboard
1. Login with admin:admin and set a new password!
2. Create a new dashboard with the attached json code


