#!/usr/bin/env bash

# get all of the daily data from all weather stations and get list of stations
Code/get_ghcnd_data.bash ghcnd_all.tar.gz
Code/get_ghcnd_all_files.bash

# Get listing of types of data at each weather station
Code/get_ghcnd_data.bash ghcnd-inventory.txt

# Get metadata for each weather station
Code/get_ghcnd_data.bash ghcnd-stations.txt



