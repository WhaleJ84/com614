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

#
# Create the Red Funnel agency.
# Is the overarching owner of the lower entities.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "urn:ngsi-ld:GtfsAgency:RedFunnelFerries",
    "type": "GtfsAgency",
    "agencyName": "Red Funnel Ferries",
    "source": "https://www.redfunnel.co.uk/en/isle-of-wight-ferry/service-status/",
    "timezone": "Europe/London"
  }'

#
# Create the service Red Funnel agency provides.
# Contains sub-values for what the service offers.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "urn:ngsi-ld:Service:Southampton:RedFunnel",
    "type": "GtfsService",
    "name": "Red Funnel",
    "operatedBy": "urn:ngsi-ld:GtfsAgency:RedFunnelFerries"
  }'

#
# Create the route between Southampton and IOW.
# There is no individual ferry tied to this route.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "urn:ngsi-ld:GtfsRoute:Southampton:IOW:T1",
    "type": "GtfsRoute",
    "name": "Isle of Wight Ferry",
    "routeType": "4",
    "operatedBy": "urn:ngsi-ld:GtfsAgency:RedFunnelFerries"
  }'

#
# Create the stop at Southampton Terminal 1.
# Is linked to the Red Funnel agency.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "urn:ngsi-ld:GtfsStop:Southampton:T1",
    "type": "GtfsStop",
    "code": "Southampton T1",
    "name": "Southampton T1",
    "location": {
      "type": "Point",
      "coordinates": [
        -1.405212,
        50.896161
      ]
    },
    "operatedBy": ["urn:ngsi-ld:GtfsAgency:RedFunnelFerries"]
  }'

#
# Create the 17:30 trip on the Southampton<>IOW route.
# Is linked with the ferry.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "urn:ngsi-ld:GtfsTrip:Southampton:RedFunnel:1730",
    "type": "GtfsTrip",
    "hasService": "urn:ngsi-ld:Service:Southampton:RedFunnel",
    "headSign": "Southampton T1",
    "direction": 1,
    "hasRoute": "urn:ngsi-ld:GtfsRoute:Southampton:IOW:T1"
  }'

#
# Create an arrival estimation.
# Is linked with the trip, not a ferry.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "urn:ngsi-ld:ArrivalEstimation:Southampton:T1:1730",
    "type": "ArrivalEstimation",
    "hasStop": ["urn:ngsi-ld:GtfsStop:Southampton:T1"],
    "hasTrip": "urn:ngsi-ld:GtfsTrip:Southampton:RedFunnel:1730",
    "remainingTime": "PT8M5S",
    "remainingDistance": 1200,
    "headSign": "Southampton T1"
  }'

#
# Create a subscription to the server.
# Will receive notifications on remainingTime changes
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/subscriptions/' \
  -H 'Content-Type: application/json' \
  -d '{
    "description": "Notify me of all delayed ferries to Terminal 1",
    "subject": {
      "entities": [
        {
          "idPattern": "urn:ngsi-ld:ArrivalEstimation:Southampton:T1:.*",
          "type": "ArrivalEstimation"
        }
      ],
       "condition": {
        "attrs": [ "remainingTime" ]
      }
    },
    "notification": {
      "http": {
        "url": "http://subscriber:5000/subscription/ferry-delay"
      }
    }
  }'

echo -e " \033[1;32mdone\033[0m"