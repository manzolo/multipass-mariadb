#!/bin/bash

HOST_DIR_NAME=${PWD}
#------------------- Env vars ---------------------------------------------
#Number of Cpu for main VM
mainCpu=1
#GB of RAM for main VM
mainRam=1Gb
#GB of HDD for main VM
mainHddGb=10Gb
#--------------------------------------------------------------------------

#Include functions
. $(dirname $0)/script/__functions.sh 

msg_warn "Check prerequisites..."

#Check prerequisites
check_command_exists "multipass"

msg_warn "Creating vm"
multipass launch -m $mainRam -d $mainHddGb -c $mainCpu -n $VM_NAME

msg_info $VM_NAME" is up!"

msg_info "[Task 1]"
msg_warn "Mount host drive with installation scripts"

multipass mount ${HOST_DIR_NAME} $VM_NAME

multipass list

msg_info "[Task 2]"
msg_warn "Configure $VM_NAME"

cat <<EOF >${HOST_DIR_NAME}/config/docker-compose.yml
version: "3.7"

services:

  $DB_CONTAINER_NAME:
    image: $DB_CONTAINER_IMAGE
    container_name: $DB_CONTAINER_NAME
    restart: always
    volumes:
      - $DB_CONTAINER_NAME-data:/var/lib/mysql
    ports:
      - $DB_HOST_PORT:$DB_CONTAINER_PORT
    environment:
      MYSQL_ROOT_PASSWORD: $DB_ROOT_PASS

  phpmyadmin:
    image: $PHPMYADMIN_CONTAINER_IMAGE
    container_name: $PHPMYADMIN_CONTAINER_NAME
    ports:
      - $PHPMYADMIN_HOST_PORT:$PHPMYADMIN_CONTAINER_PORT
    environment:
      - PMA_HOST=$DB_CONTAINER_NAME
      - PMA_USER=$DB_ROOT_USER
      - PMA_PASSWORD=$DB_ROOT_PASS
    depends_on:
      - $DB_CONTAINER_NAME

volumes:
  $DB_CONTAINER_NAME-data:
EOF

run_command_on_vm "$VM_NAME" "${HOST_DIR_NAME}/script/_configure.sh ${HOST_DIR_NAME}"

msg_info "Check database..."
run_command_on_vm $VM_NAME $(dirname $0)/script/_create_database.sh
run_command_on_vm $VM_NAME $(dirname $0)/script/_load_data.sh

msg_info "[Task 3]"
msg_warn "Start env"
${HOST_DIR_NAME}/start.sh

echo "Phpmyadmin:"
msg_info "http://$VM_NAME:$PHPMYADMIN_HOST_PORT"
echo "Database parameters:
msg_info "$VM_NAME:$DB_HOST_PORT"
msg_info "root user:$DB_ROOT_USER"
msg_info "root password:$DB_ROOT_PASS"
msg_info "Database name:$DB_NAME"
msg_info "Database username:$DB_USER"
msg_info "Database password:$DB_PASS"
