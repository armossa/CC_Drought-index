#!/usr/bin/env bash

# > assigne to the right  the file
# whereas >> append to the right file
echo "file_name" > Data/ghcnd_all_files.txt
tar tf Data/ghcnd_all.tar.gz | grep ".dly" >> Data/ghcnd_all_files.txt