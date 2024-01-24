
# OSRM Profiles customization

## Branches hierarchy


Based on [OSRM](https://github.com/Project-OSRM/osrm-backend/) car profiles.

`master` branch follows OSRM default car profiles.

`mapotempo` branch flows `master` branch, content common customization.

`car-interurban` branch flows `mapotempo` for interurban ride.

`car-urban` branch follows `car-interurban` adjusted for urban ride.

`car` branch follows `mapotempo`, auto adjust speed based on land use.

`car-lcv` branch follows `car` but for light-commercial-vehicles routing.

`car-distance` branch follows `car` but for smart-shortest routing.

`truck-medium` branch follows `car` but for small truck.


```
master - OSRM-Car
└── mapotempo
    ├── car-interurban
    │   └── car-urban
    └── car
        ├── car-distance
        ├── truck-medium
        └── car-lcv
```

## Features

Main features included in this project can also be found in [osrm-profiles-contrib](https://github.com/Project-OSRM/osrm-profiles-contrib).

## License

Copyright © 2018 Project OSRM Contributors, Mapotempo

Distributed under the MIT License (MIT).
