#!/bin/bash

SECONDS=0

DOMAIN=$1
DIRECTORY=${DOMAIN}_recon

echo "Creating directory $DIRECTORY"

if [ -d $DIRECTORY ]
then
  rm -r $DIRECTORY
fi

mkdir $DIRECTORY

function nmap1() {
  echo "Starting nmap fast scan"
  nmap -T5 $DOMAIN >> ${DIRECTORY}/nmap
  echo -e "\nThe results of nmap fast scan are stored in ${DIRECTORY}/nmap in ${SECONDS}s"
  cat ${DIRECTORY}/nmap
}

function nmap2() {
  echo "Starting nmap version scan"
  nmap -sV -A $DOMAIN >> ${DIRECTORY}/nmap
  echo -e "\nThe results of nmap version scan are stored in ${DIRECTORY}/nmap in ${SECONDS}s"
  cat ${DIRECTORY}/nmap
}

function nmap3() {
  echo "Starting nmap vuln scan"
  nmap -sC --script vuln $DOMAIN >> ${DIRECTORY}/nmap
  echo -e "\nThe results of nmap vuln scan are stored in ${DIRECTORY}/nmap in ${SECONDS}s"
  cat ${DIRECTORY}/nmap
}

function gobuster1() {
  echo "Starting gobuster common dir scan"
  gobuster dir -u $DOMAIN -w /usr/share/wordlists/dirb/common.txt >> ${DIRECTORY}/gobuster
  echo -e "\nThe results of gobuster common dir scan are stored in ${DIRECTORY}/gobuster in ${SECONDS}s"
  cat ${DIRECTORY}/gobuster
}

#function hydra() {
#  echo "Starting hydra attack"
#  hydra -l /usr/share/wordlists/seclists/Usernames/top-usernames-shortlist.txt -P /usr/share/wordlists/seclists/Passwords/Common-Credentials/best110.txt ssh://$DOMAIN >> ${DIRECTORY}/hydra
#  echo -e "\nThe results of hydra attack are stored in ${DIRECTORY}/hydra in ${SECONDS}s"
#}

#function gobuster2() {
#  echo "Starting gobuster (not so) small dir scan"
#  gobuster dir -u $DOMAIN -w /usr/share/wordlists/dirbuster/directory-list-2.3-small.txt >> ${DIRECTORY}/gobuster
#  echo -e "\nThe results of gobuster small dir scan are stored in $DIRECTORY/gobuster in ${SECONDS}s"
#  cat ${DIRECTORY}/gobuster
#}

nmap1 & nmap2 & nmap3 & gobuster1 #& hydra #gobuster2
