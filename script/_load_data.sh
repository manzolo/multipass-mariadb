#!/bin/bash

source $(dirname $0)/__functions.sh
IMPORT_FILE=$(dirname $0)'/../data/db.sql'

if test -f "$IMPORT_FILE"; then
    msg_warn "Import data into database..."
    cat $IMPORT_FILE | docker exec -i $DB_CONTAINER_NAME sh -c "mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS "$DB_NAME

    mv $IMPORT_FILE $IMPORT_FILE".done"
    msg_info "Database ready!"
else
    msg_warn "Nothing to do..."
fi