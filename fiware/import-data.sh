#!/bin/bash
#
#  curl commands to load in test data
#

set -e

printf "⏳ Loading context data "

#
# Create Port of Southampton entity
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d '{
    "id":"urn:ngsi-ld:SeaPort:Southampton-001",
    "type":"SeaPort",
    "typeOfPort":[
      "marina",
      "merchandise",
      "cruise",
      "ferry",
      "yatching"
    ],
    "location":{
      "type":"Point",
      "coordinates":[
        50.909704,
        -1.435713
      ]
    },
    "dateLastReported":"2021-10-14T08:45:00Z"
  }'


#
# Create a ferry entity linked to the port.
# Passenger boats do not require BoatPlacesAvailable according to standard.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "urn:ngsi-ld:BoatAuthorized:Ferry-001",
    "type": "BoatAuthorized",
    "refSeaPort": "urn:ngsi-ld:SeaPort:Southampton-001",
    "boatType": "passenger",
    "boatSubType": "ferry",
    "location": {
      "type": "Point",
      "coordinates": [
        50.803107295830706,
        -1.2930810631393936
      ]
    },
    "dateLastReported": "2021-10-14T23:59:59"
  }'

#
# Create a ferry terminal.
# As ferry is linked to port, need to find way to link with terminal also.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "urn:ngsi-ld:Station:FerryTerminal:1",
    "name": "Red Funnel Terminal 1",
    "type": "TransportStation",
    "location": {
      "type": "Point",
      "coordinates": [
        50.896182982117274,
        -1.4052251025225824
      ]
    },
    "dateLastReported": "2021-10-14T08:45:00Z",
    "dateObserved": "2021-10-14T08:45:00Z",
    "stationType": [
      "ferry"
    ],
    "locationType": 1
  }'

#
# Create an outgoing bus stop.
# Right outside the ferry terminal.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "urn:ngsi-ld:Station:BusStop:sohawtm",
    "name": "Red Funnel Terminal",
    "type": "TransportStation",
    "location": {
      "type": "Point",
      "coordinates": [
        50.89616791081328,
        -1.4048887338183156
      ]
    },
    "dateLastReported": "2021-10-14T08:45:00Z",
    "dateObserved": "2021-10-14T08:45:00Z",
    "stationType": [
      "bus"
    ],
    "locationType": 0,
    "webSite": "https://www.bluestarbus.co.uk/live/1980HA120546"
  }'

#
# Create a bus.
# Follows the route with the above stop.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "vehicle:bus:1",
    "type": "Vehicle",
    "vehicleType": "bus",
    "category": ["tracked", "public"],
    "location": {
      "type": "Point",
      "coordinates": [
        -3.164485591715449,
        40.62785133667262
      ]
    }
  }'

echo -e " \033[1;32mdone\033[0m"