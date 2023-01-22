#!/bin/bash

HOST_DIR_NAME=${PWD}

#Include functions
source $(dirname $0)/script/__functions.sh 

msg_warn "Starting vm"
multipass start $VM_NAME

msg_warn "Mount host drive with installation scripts"
multipass mount ${HOST_DIR_NAME} $VM_NAME

msg_info "Check database..."

run_command_on_vm $VM_NAME "$(dirname $0)/script/_backup_db.sh $HOST_DIR_NAME"
