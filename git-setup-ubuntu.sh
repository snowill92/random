#!/bin/bash
clear
spacer="---------------------------------------------------------------"
echo $spacer
echo "OK, Start the setup for git"
echo "Logged in as right user & continue? - Y/n: "
echo $spacer

read -s -n 1 resp
if [ "$resp" = "" ]; then
	resp=y
fi
if [ "$resp" = "y" ]; then

	sudo apt-get -y install git

	clear
	echo $spacer
	echo "What is your User Name?"
	echo $spacer
	echo -n "Enter Name and hit [ENTER]:"
	read username
	echo $spacer
	echo "What is your User Email?"
	echo $spacer
	echo -n "give me the email and [ENTER]:"
	read email
	echo $spacer

	git config --global user.name \"$username\"
	git config --global user.email \"$email\"

	clear
	echo $spacer
	echo "What is the repo called?"
	echo $spacer
	echo -n "Enter Name and hit [ENTER]:"
	read repodir

	clear
	git init $repodir

	cd $repodir

	git remote add origin https://github.com/$username/$repodir.git

	git pull origin master

	echo $spacer
	echo "All Done!"
else
	echo "Quitting, Bye"
fi

exit 1

