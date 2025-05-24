#!/bin/bash
cd "$(dirname "$(dirname "$(dirname "$0")")")"
git pull
docker-compose build
docker-compose up -d 