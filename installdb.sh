#!/bin/bash

# exit if a command fails
set -e

# install pg_dump
apk update
apk add --no-cache postgresql14