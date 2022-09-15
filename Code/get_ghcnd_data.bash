#!/usr/bin/env bash

file=$1
rm Data/$file
wget -P Data/ https://www.ncei.noaa.gov/pub/data/ghcn/daily/$file
