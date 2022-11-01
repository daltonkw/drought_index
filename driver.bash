#!/usr/bin/env bash

# get all daily data from all weather stations
code/get_ghcnd_data.bash ghcnd_all.tar.gz
code/get_ghcnd_all_files.bash

# get listing types of data found at each station
code/get_ghcnd_data.bash ghcnd-inventory.txt

# get metadata from each station
code/get_ghcnd_data.bash ghcnd-stations.txt

