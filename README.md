# Cloud Computing and Virtualisation

This repository holds the collaborative group work for COM614 Cloud Computing and Virtualisation.

## Structure

```
├── docs     # Documentation of entity standards
├── entities # Holds JSON entities for Fiware
├── fiware   # Docker-compose Fiware test network
```

### Fiware

To run the instance, inside the fiware directory simply run `./services.sh start`.
This will spin up the docker containers and import all the data automatically.

## Scenario

It is 2021/10/21 and a Red Funnel ferry is coming inbound from the Isle of Wight into Southampton.
The ferry is expected to arrive at Terminal 1 between 17:00 and 17:30, with a Bluestar Quayconnect bus also expected to arrive just outside at 17:30.

With no delay, there is a high possibility that passengers can get off and in a short while be on their expected bus.
However, should the journey take the full 60 minutes or more, passengers will miss the bus and have to wait 40 minutes for the next.

This prototype will utilise FIWARE and relevant standards to build a system where should the ferry be expected to miss arrival for the bus, an update will be sent to a subscriber.
With this subscription sent, it could be expanded to notify taxi services to be on standby, for example.
