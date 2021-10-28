# Entities

Documents for the entities can be found in the docs directory.

## Port

### SeaPort

As specified in the standard, all boats must have a reference seaport.
This seaport will be loosely based around the Port of Southampton.

### BoatPlacesAvailable

**NOT NEEDED:** specification states passenger boats do not require one for mooring.

### BoatAuthorized:Passenger:Ferry

A non-existent ferry that will be used as a dummy to manipulate the ETA values.
We can use [arrivalTime](https://schema.org/BoatTrip) attribute specified for BoatTrip schemas.

## Transportation

### Station:FerryTerminal

A ferry terminal for the ferry to dock at.

### Station:BusStop

A bus stop right by the ferry station.
Can get open data from [here](https://www.bluestarbus.co.uk/open-data).

### Vehicle:Bus

A non-existent bus that will stop at the one outlined above.

## Urban Mobility

### GtfsAgency:RedFunnelFerries

The Red Funnel agency that provides ferry services to Southampton and the Isle of Wight.

### GtfsService:Southampton:RedFunnel

The service that the Red Funnel agency provides to customers.

### GtfsRoute:Southampton:IOW:T1

The route between Southampton and the Isle of Wight.

### GtfsStop:Southampton:T1

The stop at Southampton T1 for the Red Funnel agency.

### GtfsTrip:Southampton:RedFunnel:1730

The trip on the Southampton<>IOW route that is scheduled to arrive at 17:30.

### ArrivalEstimation:Southampton:T1:1730

The arrival estimation for the ferry service arriving at Southampton T1 at 17:30.
