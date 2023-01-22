#!/bin/bash

#Include functions
source $(dirname $0)/script/__functions.sh

msg_warn "== Clean vm"

source $(dirname $0)/stop.sh

echo "remove $VM_NAME"
multipass delete $VM_NAME
multipass purge
multipass list

rm -rf "./script/_test.sh"
rm -rf "./config/hosts"

msg_info "== Vm clear"
