#!/bin/bash

## Ejecutable quepermite cambiar las versiones de php en el sistema linux

PHP_VERSION=$1

function showWarning() {
	START='\033[01;33m'
	END='\033[00;00m'
	MESSAGE=$1
	echo -e "${START}${MESSAGE}${END}"
}

function showInfo() {
	START='\033[01;36m'
	END='\033[00;00m'
	MESSAGE=$1
	echo -e "${START}${MESSAGE}${END}"
}

function showSuccess() {
	START='\033[01;32m'
	END='\033[00;00m'
	MESSAGE=$1
	echo -e "${START}${MESSAGE}${END}"
}

function showError() {
	START='\033[01;31m'
	END='\033[00;00m'
	MESSAGE=$1
	echo -e "${START}${MESSAGE}${END}"
}

# Extraer el numero de la version de php
PHP_VERSION=${PHP_VERSION//[a-zA-Z]/}

ARR_VERSIONS_PHP[0]="7.4"
ARR_VERSIONS_PHP[1]="8.0"
ARR_VERSIONS_PHP[2]="8.1"

LENGTH=${#ARR_VERSIONS_PHP[@]}

showWarning "Ejecutando..."
showInfo "Versiones de php registradas! ${ARR_VERSIONS_PHP[@]}"

EXIST="0"
# Comprobar la existencia de la version de php
for version in "${ARR_VERSIONS_PHP[@]}"; 
do
    if [[ "$version" == "$PHP_VERSION" ]];
        then
        EXIST="1"        
    fi
done

if [[ "$EXIST" == "0" ]];
    then
    showError "ERROR: La version '${PHP_VERSION}' de php ingresada no registrada."
    exit
fi

# Deshabilitar las versions de php
for version in "${ARR_VERSIONS_PHP[@]}"; 
    do
    sudo a2dismod php$version
done

# Activar la version de php ingresada en el sistema
sudo update-alternatives --set php /usr/bin/php$PHP_VERSION
sudo update-alternatives --set phar /usr/bin/phar$PHP_VERSION
sudo update-alternatives --set phar.phar /usr/bin/phar.phar$PHP_VERSION

sudo a2enmod php$PHP_VERSION

sudo systemctl restart apache2
sudo systemctl restart mysql

showSuccess "Ejecucion OK"

