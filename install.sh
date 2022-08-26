#!/bin/bash

####
# Installation Instructions
#
# wget https://github.com/jychoy92/SyslogForwarder/raw/main/install.sh -O install.sh; bash install.sh
#
####

## TEXT OUTPUT COLORS
NORMAL="\e[0m"
BLUE="\e[94m"
CYAN="\e[96m"
RED="\e[91m"
MAGENTA="\e[35m"
LGREEN="\e[92m"
GREEN="\e[32m"
ITALIC="\e[3m"

## Installation Repo URL
INSTALL_REPO="https://github.com/jychoy92/SyslogForwarder.git"

function update_server() {
    echo ''
    echo -e "${CYAN}Updating OS packages ...${NORMAL}"
    echo ''
    sudo apt clean all;
    sudo apt update;
    sudo apt --yes dist-upgrade;
    sudo apt --yes autoremove
}

function install_ansible() {
    echo ''
    echo -e "${CYAN}Installing Ansible packages ...${NORMAL}"
    echo ''
    sudo apt install --yes ansible;
}

function clone_install_repo() {

    if [ -d "SyslogForwarder" ]; then
        rm -fr "SyslogForwarder";
    fi
    echo ''
    echo -e "${CYAN}Downloading SyslogForwarder Ansible Playbooks ...${NORMAL}"
    echo ''
    git clone ${INSTALL_REPO};

}

function start_SyslogForwarder_installation() {

    echo ''
    echo -e "${CYAN}Initiating SyslogForwarder Installation ...${NORMAL}"

    echo -e "${BLUE}Region Alpha-2 Code in small letter (e.g.: sg, pl, my, vn, cn, id)${NORMAL}"
    echo -e "${GREEN}Country Code Reference: https://www.iban.com/country-codes ${GREEN}"
    until [[ $region_letters ]]; do read -p "> " region_letters; done

    echo -e "${BLUE}Logstash Server 1 URL (e.g.: logstash1.siem.cit.sea.com )${NORMAL}"
    until [[ $logstach_server1 ]]; do read -p "> " logstach_server1; done

    echo -e "${BLUE}Logstash Server 2 URL (e.g.: logstash2.siem.cit.sea.com )${NORMAL} ${GREEN}Leave blank if no input ${GREEN}"
    read -p "> " logstach_server2;

    echo -e "${BLUE}WAN Firewall 01 IP (e.g.: 10.2.0.3 )${NORMAL} ${GREEN}Leave blank if no input ${GREEN}"
    read -p "> " ip_wanfirewall1;

    echo -e "${BLUE}WAN Firewall 02 IP (e.g.: 10.2.0.4 )${NORMAL} ${GREEN}Leave blank if no input ${GREEN}"
    read -p "> " ip_wanfirewall2;

    echo -e "${BLUE}Core Firewall 01 IP (e.g.: 10.2.0.5 )${NORMAL} ${GREEN}Leave blank if no input ${GREEN}"
    read -p "> " ip_corefirewall1;

    echo -e "${BLUE}Core Firewall 02 IP (e.g.: 10.2.0.6 )${NORMAL} ${GREEN}Leave blank if no input ${GREEN}"
    read -p "> " ip_corefirewall2;

    echo -e "${BLUE}WLC 01 IP (e.g.: 10.2.0.11 )${NORMAL} ${GREEN}Leave blank if no input ${GREEN}"
    read -p "> " ip_wlc1;

    echo -e "${BLUE}WLC 02 IP (e.g.: 10.2.0.12 )${NORMAL} ${GREEN}Leave blank if no input ${GREEN}"
    read -p "> " ip_wlc2;

    echo -e "${BLUE}Switches IP (Put prefix of the range, e.g.: put 10.1.1. if switches range is 10.1.1.0-265 )${NORMAL} ${GREEN}Leave blank if no input ${GREEN}"
    read -p "> " ip_switches;

    echo -e "${BLUE}Synology NAS IP (e.g.: 10.2.11.60 )${NORMAL} ${GREEN}Leave blank if no input ${GREEN}"
    read -p "> " ip_synology;

    echo -e "${BLUE}vCenter IP (e.g.: 10.2.11.70 )${NORMAL} ${GREEN}Leave blank if no input ${GREEN}"
    read -p "> " ip_vcenter;

    echo ''

    ansible-playbook -i hosts playbook_syslogforwarder.yml \
    -e "region_letters=${region_letters}" \
    -e "logstach_server1=${logstach_server1}" \
    -e "logstach_server2=${logstach_server2}" \
    -e "ip_wanfirewall1=${ip_wanfirewall1}" \
    -e "ip_wanfirewall2=${ip_wanfirewall2}" \
    -e "ip_corefirewall1=${ip_corefirewall1}" \
    -e "ip_corefirewall2=${ip_corefirewall2}" \
    -e "ip_wlc1=${ip_wlc1}" \
    -e "ip_wlc2=${ip_wlc2}" \
    -e "ip_switches=${ip_switches}" \
    -e "ip_synology=${ip_synology}" \
    -e "ip_vcenter=${ip_vcenter}";
}


## Main Processing Function
## This function calls all the primary execution functions

function main() {

    cd /root

    update_server
    install_ansible
    clone_install_repo

    cd /root/SyslogForwarder/
    start_SyslogForwarder_installation
}


## BEGIN SCRIPT PROCESS
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root user.${NORMAL}" 
   exit 1
else
    # Start installation process
    echo ''
    echo -e "${CYAN}Starting the installation process ...${NORMAL}"
    main

    # Installation complete
    echo ''
    echo -e "${GREEN}Installation has been completed.${NORMAL}"
    echo ''
fi
