#!/bin/bash

source envcontainers.env

while IFS= read -r line  || [ -n "$line" ]; do
    if [ ! "${line:0:1}" == "#" ]; then
        if [ ! "${line}" == "" ]; then
            r=$(eval "echo $line")
            opts+=(--build-arg "$r")
        fi
    fi
done < "envcontainers.env"

echo "${opts[@]}"