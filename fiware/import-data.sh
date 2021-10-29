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
  -d @/entities/port/SeaPort.json

#
# Create a ferry entity linked to the port.
# Passenger boats do not require BoatPlacesAvailable according to standard.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d @/entities/port/BoatAuthorized:Ferry.json

#
# Create a ferry terminal.
# As ferry is linked to port, need to find way to link with terminal also.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d @/entities/transportation/Station:FerryTerminal.json

#
# Create an outgoing bus stop.
# Right outside the ferry terminal.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d @/entities/transportation/Station:BusStop.json

#
# Create a bus.
# Follows the route with the above stop.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d @/entities/transportation/Vehicle:Bus-1.json

#
# Create the Red Funnel agency.
# Is the overarching owner of the lower entities.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d @/entities/urban_mobility/GtfsAgency:RedFunnelFerries.json

#
# Create the service Red Funnel agency provides.
# Contains sub-values for what the service offers.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d @/entities/urban_mobility/GtfsService:Southampton:RedFunnel.json

#
# Create the route between Southampton and IOW.
# There is no individual ferry tied to this route.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d @/entities/urban_mobility/GtfsRoute:Southampton:IOW:T1.json

#
# Create the stop at Southampton Terminal 1.
# Is linked to the Red Funnel agency.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d @/entities/urban_mobility/GtfsStop:Southampton:T1.json

#
# Create the 17:30 trip on the Southampton<>IOW route.
# Is linked with the ferry.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d @/entities/urban_mobility/GtfsTrip:Southampton:RedFunnel:1730.json

#
# Create an arrival estimation.
# Is linked with the trip, not a ferry.
#
curl -s -o /dev/null -X POST \
  'http://orion:1026/v2/entities?options=keyValues' \
  -H 'Content-Type: application/json' \
  -d @/entities/urban_mobility/ArrivalEstimation:Southampton:T1:1730.json

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