#!/bin/bash
#
#  DISCLAIMER: This script has been modified from the FIWARE tutorial series
#  Please see here: https://github.com/FIWARE/tutorials.NGSI-v2/tree/97fc7d24922ffa0c8b12bb3a9cb69d011fe7c6cc
#

set -e

dockerCmd="docker-compose"

if (( $# < 1 )); then	echo "Illegal number of parameters"
	echo "usage: services [create|start|stop]"
	exit 1
fi

loadData () {
	docker run --rm -v "$(pwd)"/import-data.sh:/import-data \
	  -v "$(pwd)"/../entities/:/entities/ \
		--network fiware_default \
		--entrypoint /bin/ash curlimages/curl import-data
	echo ""
}

displayServices () {
	echo ""
	docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter name=fiware-*
	echo ""
}

stoppingContainers () {
	echo "Stopping running containers"
	${dockerCmd} down -v --remove-orphans
}

addDatabaseIndex () {
	printf "Create \033[1mMongoDB\033[0m database indexes ..."
	docker exec  db-mongo mongo --eval '
	conn = new Mongo();db.createCollection("orion");
	db = conn.getDB("orion");
	db.createCollection("entities");
	db.entities.createIndex({"_id.servicePath": 1, "_id.id": 1, "_id.type": 1}, {unique: true});
	db.entities.createIndex({"_id.type": 1});
	db.entities.createIndex({"_id.id": 1});' > /dev/null
	echo -e " \033[1;32mdone\033[0m"
}

waitForMongo () {
	echo -e "\n⏳ Waiting for \033[1mMongoDB\033[0m to be available\n"
	while ! [ `docker inspect --format='{{.State.Health.Status}}' db-mongo` == "healthy" ]
	do
		sleep 1
	done
}

waitForOrion () {
	echo -e "\n⏳ Waiting for \033[1;34mOrion\033[0m to be available\n"

	while ! [ `docker inspect --format='{{.State.Health.Status}}' fiware-orion` == "healthy" ]
	do
	  echo -e "Context Broker HTTP state: " `curl -s -o /dev/null -w %{http_code} 'http://localhost:1026/version'` " (waiting for 200)"
	  sleep 1
	done
}

command="$1"
case "${command}" in
	"help")
		echo "usage: services [create|start|stop]"
		;;
	"start")
		stoppingContainers
		echo -e "Starting containers:  \033[1;34mOrion\033[0m and a \033[1mMongoDB\033[0m database."
		echo -e "- \033[1;34mOrion\033[0m is the context broker"
		echo ""
		${dockerCmd} up -d --remove-orphans
		waitForMongo
		addDatabaseIndex
		waitForOrion
		loadData
		displayServices
		echo -e "Now open \033[4mhttp://localhost:5000/schedule"
		;;
	"stop")
		stoppingContainers
		;;
	"create")
		echo "Pulling Docker images"
		docker pull curlimages/curl
		${dockerCmd} pull
		;;
	*)
		echo "Command not Found."
		echo "usage: services [create|start|stop]"
		exit 127;
		;;
esac