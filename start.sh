#!/bin/bash

HOST_DIR_NAME=${PWD}

#Include functions
source $(dirname $0)/script/__functions.sh 

msg_warn "Starting vm"
multipass start $VM_NAME

msg_info "$VM_NAME started!"

. $(dirname $0)/script/_hosts_manager.sh

removehost
addhost

echo "------------------------------------------------"
echo "Phpmyadmin:"
msg_info "http://$VM_NAME:$PHPMYADMIN_HOST_PORT"
echo "Database parameters:"
msg_info "$VM_NAME:$DB_HOST_PORT"
msg_info "root user:$DB_ROOT_USER"
msg_info "root password:$DB_ROOT_PASS"
msg_info "Database name:$DB_NAME"
msg_info "Database username:$DB_USER"
msg_info "Database password:$DB_PASS"
echo ""
echo "Useful command:"
echo "Backup database:"
msg_warn "./backupdb.sh"
echo "Restore database:"
msg_warn "./restoredb.sh database_backup_filename.sql"

echo ""
msg_warn "Shell on "$VM_NAME
msg_info "multipass shell "$VM_NAME
echo ""

echo "Start VM:"
msg_warn "./start.sh"
echo "Stop VM:"
msg_warn "./stop.sh"
echo "Uninstall VM:"
msg_warn "./uninstall.sh"
echo "------------------------------------------------"
