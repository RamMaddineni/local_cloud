#!/bin/bash
cd /home/$(whoami)/Desktop/repos/local_cloud
git pull
docker-compose build
docker-compose up -d 