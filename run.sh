#!/bin/bash

while :; do
	echo "[Info][$(date)] Starting SpeedTest++..."
	JSON=$(./SpeedTest/SpeedTest --output json)
	DOWNLOAD=$(echo ${JSON} | jq -r .download)
	UPLOAD=$(echo ${JSON} | jq -r .upload)
	PING=$(echo ${JSON} | jq -r .ping)
	JITTER=$(echo ${JSON} | jq -r .jitter)
	UPLOAD=$(echo $UPLOAD | sed 's/\(\.[0-9][0-9]\)[0-9]*/\1/g')
	DOWNLOAD=$(echo $DOWNLOAD | sed 's/\(\.[0-9][0-9]\)[0-9]*/\1/g')
	echo "[Info][$(date)] Speedtest results - Download: ${DOWNLOAD}, Upload: ${UPLOAD}, Ping: ${PING}, Jitter: ${JITTER}"
	curl -sL -XPOST "${INFLUXDB_URL}/write?db=${INFLUXDB_DB}" --data-binary "download,host=${SPEEDTEST_HOST} value=${DOWNLOAD}"
	curl -sL -XPOST "${INFLUXDB_URL}/write?db=${INFLUXDB_DB}" --data-binary "upload,host=${SPEEDTEST_HOST} value=${UPLOAD}"
	curl -sL -XPOST "${INFLUXDB_URL}/write?db=${INFLUXDB_DB}" --data-binary "ping,host=${SPEEDTEST_HOST} value=${PING}"
	curl -sL -XPOST "${INFLUXDB_URL}/write?db=${INFLUXDB_DB}" --data-binary "jitter,host=${SPEEDTEST_HOST} value=${JITTER}"
	echo "[Info][$(date)] Sleeping for ${SPEEDTEST_INTERVAL} seconds..."
	sleep ${SPEEDTEST_INTERVAL}
done
