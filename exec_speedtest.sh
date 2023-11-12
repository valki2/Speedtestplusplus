#!/bin/bash
docker stop speedtest_once
docker rm speedtest_once
docker run  --name speedtest_once -e SPEEDTEST_INTERVAL="600" -e SPEEDTEST_HOST="speedtest.telfs.com:8080"  -e INFLUXDB_DB="speedtest" -e INFLUXDB_URL="http://influxdb:8086" -e TZ="Europe/Berlin" --network=speedtestnet valki/speedtestplusplus:once
