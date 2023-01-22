#!/bin/bash

# copy from https://gist.github.com/irazasyed/a7b0a079e7727a4315b9

HOST_DIR_NAME=${PWD}

#Include functions
#source $(dirname $0)/__functions.sh 

# PATH TO YOUR HOSTS FILE
ETC_HOSTS=/etc/hosts

# DEFAULT IP FOR HOSTNAME
IP=$(multipass info $VM_NAME | grep IPv4 | awk '{print $2}')
# Hostname to add/remove.

removehost() {
    msg_warn "removing host entry";
    if [ -n "$(grep $VM_NAME /etc/hosts)" ]
    then
        msg_warn "$VM_NAME Found in your $ETC_HOSTS, Removing now...";
        sudo sed -i".bak" "/$VM_NAME/d" $ETC_HOSTS
    else
        msg_warn "$VM_NAME was not found in your $ETC_HOSTS";
    fi
}

addhost() {
    msg_warn "adding host entry ";
    HOSTS_LINE="$IP\t$VM_NAME"
    if [ -n "$(grep $VM_NAME /etc/hosts)" ]
        then
            msg_warn "$VM_NAME already exists : $(grep $VM_NAME $ETC_HOSTS)"
        else
            msg_warn "Adding $VM_NAME to your $ETC_HOSTS";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

            if [ -n "$(grep $VM_NAME /etc/hosts)" ]
                then
                    msg_info "$VM_NAME was added succesfully \n $(grep $VM_NAME /etc/hosts)";
                else
                    msg_error "Failed to Add $VM_NAME, Try again!";
            fi
    fi
}


