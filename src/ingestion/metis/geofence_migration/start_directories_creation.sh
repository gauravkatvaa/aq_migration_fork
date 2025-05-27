#!/bin/bash
#update this path to deployment location
BASEDIR=$(dirname $(realpath "$0"))
cd $BASEDIR
python3.8 createDirectories.py