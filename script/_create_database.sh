#!/bin/bash

source $(dirname $0)/__functions.sh

msg_warn "Create database..."
sleep 30

CREATE_DB_CMD="CREATE DATABASE $DB_NAME;"
MYSQL_CMD="mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e '$CREATE_DB_CMD'"
docker exec -i $DB_CONTAINER_NAME sh -c "$MYSQL_CMD"

msg_warn "Create user database..."

CREATE_USER_CMD="CREATE OR REPLACE USER $DB_USER@localhost IDENTIFIED BY \"$DB_PASS\" ;"
MYSQL_CMD="mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e '$CREATE_USER_CMD'"
docker exec -i $DB_CONTAINER_NAME sh -c "$MYSQL_CMD"

CREATE_USER_CMD="CREATE OR REPLACE USER $DB_USER@\"%\" IDENTIFIED BY \"$DB_PASS\" ;"
MYSQL_CMD="mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e '$CREATE_USER_CMD'"
docker exec -i $DB_CONTAINER_NAME sh -c "$MYSQL_CMD"

msg_warn "Grant user database..."

CREATE_USER_GRANT_CMD="GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@localhost;"
MYSQL_CMD="mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e '$CREATE_USER_GRANT_CMD'"
docker exec -i $DB_CONTAINER_NAME sh -c "$MYSQL_CMD"

CREATE_USER_GRANT_CMD="GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@\"%\" ; "
MYSQL_CMD="mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e '$CREATE_USER_GRANT_CMD'"
docker exec -i $DB_CONTAINER_NAME sh -c "$MYSQL_CMD"

CREATE_USER_GRANT_CMD="GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@\"%\";"
MYSQL_CMD="mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e '$CREATE_USER_GRANT_CMD'"
docker exec -i $DB_CONTAINER_NAME sh -c "$MYSQL_CMD"

msg_warn "Apply grant user database..."
CREATE_FLUSH_USER_GRANT_CMD="FLUSH PRIVILEGES;"
MYSQL_CMD="mysql -u$DB_ROOT_USER -p$DB_ROOT_PASS -e '$CREATE_FLUSH_USER_GRANT_CMD'"
docker exec -i $DB_CONTAINER_NAME sh -c "$MYSQL_CMD"

msg_info "Database ready!"
