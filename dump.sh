#!/bin/bash

set -e
set -o pipefail

# Verify POSTGRES_* parameters
if [ "${POSTGRES_HOST}" = "**None**" ]; then
  echo "You need to set the POSTGRES_HOST environment variable."
  exit 1
fi

if [ "${POSTGRES_DATABASE}" = "**None**" ]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [ "${POSTGRES_USER}" = "**None**" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [ "${POSTGRES_PASSWORD}" = "**None**" ]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable."
  exit 1
fi

# Set parameters for dump
export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER"

# Dump the database

databases=$(echo $POSTGRES_DATABASE | tr "," "\n")

for db in $databases
do
    echo "Creating dump of database ${db} from host ${POSTGRES_HOST}"
    BACKUP_FILE_NAME="$db"_$(date +"%Y-%m-%dT%H_%M_%SZ")
    BACKUP_FILE=$BACKUP_DIR/$BACKUP_FILE_NAME

    pg_dump $POSTGRES_HOST_OPTS $POSTGRES_EXTRA_OPTS ${db} --file=$BACKUP_FILE

    echo "Dump and transfer completed, filename: $BACKUP_FILE_NAME"

done

