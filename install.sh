#!/bin/bash
function main(){
    if rpm --query centos-release | grep -q 'centos-release-6'; then
        echo "Install on Centos 6..."
        centos6
        exit
    elif rpm --query centos-release | grep -q 'centos-release-7'; then
        echo "Install on Centos 7..."
        centos7
        exit
    else
        echo "CyberPanel needs to be installed on CentOS 6.X, 7.X system!"
        exit
    fi
}

function centos6(){
    before
}

function centos7(){
    before    
}

function before(){
    RAM=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')
    DISK=$(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}')

    if systemctl is-active mysqld | grep -q 'active'; then

        echo "MariaDB database installed."
    else
        echo -e "		OpenLiteSpeed Installer

  RAM check : $RAM 

  Recommended minimal \e[31m512MB\e[39m for MariaDB database installation.

  Disk check : $DISK (Minimal \e[31m10GB\e[39m free space)

  1. Install MariaDB database.

  2. Do not install MariaDB database.

  3. Exit.

    "
        echo && stty erase '^H' && read -p "Please enter the number[1-3]: " num
        echo ""
        case "$num" in
            1)
            maria_db
            ;;
            2)
            ;;
            3)
            exit
            ;;
            *)
            echo -e "${Error} please enter the right number [1-3]"
            ;;
        esac
    fi
}

function maria_db(){
    echo -e "		CyberPanel Installer

  RAM check : $RAM 

  You have selected \e[31m$MYSQL_number2\e[39m, Please be mind with RAM requirement.

  For MariaDB \e[31m10.0\e[39m, Recommended minimal \e[31m512MB\e[39m RAM.

  For MariaDB \e[31m10.1\e[39m and above, Recommended \e[31m1GB\e[39m RAM.

  1. Install MariaDB \e[31m10.0\e[39m

  2. Install MariaDB \e[31m10.1\e[39m

  3. Install MariaDB \e[31m10.2\e[39m

  4. Install MariaDB \e[31m10.3\e[39m

  5. Exit.

    "
}

if [ $UID -ne 0 ]; then
    echo "Superuser privileges are required to run this script."
    echo "e.g. \"sudo $0\""
    exit 1
else
echo -e "\nYou are runing on root..."
fi

main