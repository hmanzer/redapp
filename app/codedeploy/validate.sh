#!/bin/bash
OUTPUT=$(curl -v --silent localhost:8080 2>&1 | grep 200)
if [-z "$OUTPUT" ]
then
    exit 1
fi
exit 0