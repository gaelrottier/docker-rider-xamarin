#!/usr/bin/env bash

docker run -tdi \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v ${HOME}/.Rider2017.2_docker:/home/developer/.Rider2017.2 \
           dlsniper/docker-intellij
