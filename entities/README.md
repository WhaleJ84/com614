# Entities

Documents for the entities can be found in the docs directory.

## SeaPort

As specified in the standard, all boats must have a reference seaport.
This seaport will be loosely based around the Port of Southampton.

## BoatPlacesAvailable

**NOT NEEDED:** specification states passenger boats do not require one for mooring.

## BoatAuthorized:Passenger:Ferry

A non-existent ferry that will be used as a dummy to manipulate the ETA values.
We can use [arrivalTime](https://schema.org/BoatTrip) attribute specified for BoatTrip schemas.

## Station:FerryTerminal

A ferry terminal for the ferry to dock at.

## Station:BusStop

A bus stop right by the ferry station.
Can get open data from [here](https://www.bluestarbus.co.uk/open-data).

## Vehicle:Bus

A non-existent bus that will stop at the one outlined above.
