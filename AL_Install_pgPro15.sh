#!/bin/bash

# Version 2022-12-06
set -e # Exit immediately if a command exits with a non-zero status.

#вспомогательные функции
function echo-red     { COLOR='\033[31m' ; NORMAL='\033[0m' ; echo -e "${COLOR}$1${NORMAL}"; }
function echo-green   { COLOR='\033[32m' ; NORMAL='\033[0m' ; echo -e "${COLOR}$1${NORMAL}"; }
function echo-yellow  { COLOR='\033[33m' ; NORMAL='\033[0m' ; echo -e "${COLOR}$1${NORMAL}"; }
function echo-blue    { COLOR='\033[34m' ; NORMAL='\033[0m' ; echo -e "${COLOR}$1${NORMAL}"; }
function echo-magenta { COLOR='\033[35m' ; NORMAL='\033[0m' ; echo -e "${COLOR}$1${NORMAL}"; }
function echo-cyan    { COLOR='\033[36m' ; NORMAL='\033[0m' ; echo -e "${COLOR}$1${NORMAL}"; }


echo-yellow "[ INFO ] STARTED $0  SCRIPT----- $0"

#перейдем в текущий каталог скрипта
SCRIPT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $SCRIPT_FOLDER

SUBFOLDER_NAME="distrib"
mkdir -p ./$SUBFOLDER_NAME
cd ./$SUBFOLDER_NAME

PG_SCRIPT_NAME="pgpro-repo-add.sh"
if [ -e $PG_SCRIPT_NAME ];then
    echo-yellow "[ INFO ] pgpro script already downloaded ($PG_SCRIPT_NAME)    ($0)"
else
    echo-yellow "[ INFO ] start downloading $PG_SCRIPT_NAME    ($0)"
    wget https://repo.postgrespro.ru/1c-15/keys/pgpro-repo-add.sh 

    #проверим загрузилось ли
    if [ -e $PG_SCRIPT_NAME ];then
        echo-green "[ SUCCESS ] downloaded ($PG_SCRIPT_NAME)    ($0)"
    else
        echo-red "[ ERROR ] did not finded downloaded script $PG_SCRIPT_NAME    ($0)"
        exit 111
    fi
fi

echo-blue "[ INFO ] starting $PG_SCRIPT_NAME    ($0)"
sh $PG_SCRIPT_NAME 


echo-blue "[ INFO ] installing  postgrespro    ($0)"
apt-get install postgrespro-1c-15

echo-blue "[ INFO ] setting user/password     ($0)"
sudo -u postgres /usr/bin/psql -U postgres -c "alter user postgres with password 'postgrespwd';" 

echo-blue "[ INFO ] enabling(starting) service     ($0)"
systemctl enable postgrespro-1c-15

echo-blue "[ INFO ] showing status of service     ($0)"
systemctl status postgrespro-1c-15

echo-blue "[ INFO ] FINISHED SCRIPT     ($0)"