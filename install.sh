#!/bin/bash
function webserver(){
    echo -e "		Web Server

  RAM check : $RAM 

  Disk check : $DISK

  Which server do you want to install?

  1. Install Apache.

  2. Install Nginx.

  3. Install OpenLiteSpeed.

    "

    while [[ -z "$WEBSERVER" ]]; do
        echo && stty erase '^H' && read -p "Please enter the number[1-3]: " num
        echo ""
        case "$num" in
            1)
            WEBSERVER=apache
            echo "You have selected: Apache"
            echo ""
            ;;
            2)
            WEBSERVER=nginx
            echo "You have selected: Nginx"
            echo ""
            ;;
            3)
            WEBSERVER=openlitespeed
            echo "You have selected: OpenLiteSpeed"
            echo ""
            ;;
            *)
            echo -e "${Error} please enter the right number [1-3]"
            ;;
        esac
    done
}

function phpversion(){
    echo -e "		PHP Version

  RAM check : $RAM 

  Disk check : $DISK

  Which PHP version do you want to install?

  1. Install PHP \e[31m5.6\e[39m.

  2. Install PHP \e[31m7.0\e[39m.

  3. Install PHP \e[31m7.1\e[39m.

  4. Install PHP \e[31m7.2\e[39m.

    "

    while [[ -z "$PHPVER" ]]; do
        echo && stty erase '^H' && read -p "Please enter the number[1-4]: " num
        echo ""
        case "$num" in
            1)
            PHPVER=56
            echo -e "You have selected: PHP \e[31m5.6\e[39m"
            echo ""
            ;;
            2)
            PHPVER=70
            echo -e "You have selected: PHP \e[31m7.0\e[39m"
            echo ""
            ;;
            3)
            PHPVER=71
            echo -e "You have selected: PHP \e[31m7.1\e[39m"
            echo ""
            ;;
            4)
            PHPVER=72
            echo -e "You have selected: PHP \e[31m7.2\e[39m"
            echo ""
            ;;
            *)
            echo -e "${Error} please enter the right number [1-4]"
            ;;
        esac
    done
}

function mariadbversion(){
    echo -e "		MariaDB Version

  RAM check : $RAM

  Disk check : $DISK

  Which MariaDB version do you want to install?

  1. Install MariaDB \e[31m10.0\e[39m.

  2. Install MariaDB \e[31m10.1\e[39m.

  3. Install MariaDB \e[31m10.2\e[39m.

  4. Install MariaDB \e[31m10.3\e[39m.

    "

    while [[ -z "$DBVER" ]]; do
        echo && stty erase '^H' && read -p "Please enter the number[1-4]: " num
        echo ""
        case "$num" in
            1)
            DBVER=10.0
            echo -e "You have selected: MariaDB \e[31m10.0\e[39m"
            echo ""
            ;;
            2)
            DBVER=10.1
            echo -e "You have selected: MariaDB \e[31m10.1\e[39m"
            echo ""
            ;;
            3)
            DBVER=10.2
            echo -e "You have selected: MariaDB \e[31m10.2\e[39m"
            echo ""
            ;;
            4)
            DBVER=10.3
            echo -e "You have selected: MariaDB \e[31m10.3\e[39m"
            echo ""
            ;;
            *)
            echo -e "${Error} please enter the right number [1-4]"
            ;;
        esac
    done
}

function database(){
    echo -e "		Database

  RAM check : $RAM 

  Disk check : $DISK

  Which Database do you want to install?

  1. Install MariaDB.

  2. Install PostgreSQL.

  3. Does not install.

    "

    while [[ -z "$DB" ]]; do
        echo && stty erase '^H' && read -p "Please enter the number[1-3]: " num
        echo ""
        case "$num" in
            1)
            DB=mariadb
            echo "You have selected: MariaDB"
            echo ""
            mariadbversion
            ;;
            2)
            DB=postgresql
            echo "You have selected: PostgreSQL"
            echo ""
            ;;
            3)
            DB=none
            echo "You have selected: Does not install"
            echo ""
            ;;
            *)
            echo -e "${Error} please enter the right number [1-3]"
            ;;
        esac
    done
}

function main(){
    if uname -m | grep -q 'i686'; then
        echo "Script only support on 64 bit system!"
        exit
    elif uname -m | grep -q 'i386'; then
        echo "Script only support on 64 bit system!"
        exit
    fi

    if rpm --query centos-release | grep -q 'centos-release-6'; then
        echo "Install on Centos 6..."
    elif rpm --query centos-release | grep -q 'centos-release-7'; then
        echo "Install on Centos 7..."
    else
        echo "Script only support on CentOS 6.X, 7.X system!"
        exit
    fi
    webserver
    phpversion
    database
}

if [ $UID -ne 0 ]; then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo $0\""
    exit 1
else
echo -e "\nYou are runing on root..."
fi

RAM=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')
DISK=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}')
WEBSERVER=
PHPVER=
DB=
DBVER=

main