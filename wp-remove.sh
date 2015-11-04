#!/bin/bash
clear
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root if you want toinstall the "
	echo "required Perl Modules or set up the Apache Web Server"
	echo "OK to continue Y/n"
	read -s -n 1 ans
	if [ "$ans" = "" ]; then
		ans=y
	fi
	if [ "$ans" != "y" ]; then
		echo "Quitting"
		exit 1
	fi 
fi
spacer="---------------------------------------------------------------"
echo $spacer
echo "Fucked it up yeah? - Twat!"
echo "Dissable and fully remove? - Y/n: "
echo $spacer

read -s -n 1 resp
if [ "$resp" = "" ]; then
	resp=y
fi
if [ "$resp" = "y" ]; then

	clear
	echo $spacer
	echo "Currently Installed Sites"
	echo $spacer
	ls -l /var/www/
	echo $spacer
	echo "Give me the SiteName/ SitePath"
	echo "eg /var/www/????wordpress/www"
	echo -n "Enter Name and hit [ENTER]:"
	read path1

	path=$path1'wordpress'

	a2dissite $path.conf 
	service apache2 restart
	cd /var/www/
	rm -R $path
	rm /etc/apache2/sites-available/$path.conf
	echo "Site Removed"
else
	echo "Quitting, Bye :'("
fi

exit 1

