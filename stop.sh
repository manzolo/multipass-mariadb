#!/bin/bash

HOST_DIR_NAME=${PWD}

#Include functions
. $(dirname $0)/script/__functions.sh 
. $(dirname $0)/script/_hosts_manager.sh 

removehost

msg_warn "Stop vm..."
multipass stop $VM_NAME

msg_info "$VM_NAME stopped!"
