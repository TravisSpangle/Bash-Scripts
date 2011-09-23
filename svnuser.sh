#!/bin/bash

passFile=""


function svnuserOptions {
	echo "Name______________"
	echo -e "\t $0  [--add|--update|--delete] [username] [password]" 
	echo "Description_______"
	echo -e "\tPerforms Add, Update, or Delete options on users for SVN\n\n\tThe following optiosn are available:"
	echo -e "\t--add {username} {password}"
	echo -e "\t--update {username} {password}"
	echo -e "\t--delete {username}"
	echo -e "\t--list"
	echo -e "\n\nDependencies______\n\tPassword file should be located at $passFile"
}

function confirmPassWordFileExists {
	if [ ! -frw $passFile ]; then
		echo -e "ERROR with svn passwd file. It might not exist, be readable, or writable. Check \n\t$passFile"
		exit
	fi
}

function confirmParametersExist {
#Validates parameters are present
#	will display options on failure and exit
	if [ $1 -eq 0 ]; then
		svnuserOptions
		exit
	fi

}

function isHelpFlagTrue {
	if [ $1 == "--help" ]; then
		svnuserOptions
		exit
	fi
}

function validateUserPasswordParams {
	if [ $# -ne 3 ]; then
		echo "Expected format [--add | --update] [username] [password]"
		exit
	fi
}

function validateUserParams {
	if [ $# -ne 2 ]; then
		echo "Expected format [--delete] [username]"
		exit
	fi
}

function createUpdateUser {
	validateUserPasswordParams $@
	"sudo htpasswd  -mb $passFile $2 $3"
}

function deleteUser {
	validateUserParams $@
	"sudo htpasswd -D $passFile $2"
}

# Main_____________________________________

#confirmPassWordFileExists
confirmParametersExist $#
isHelpFlagTrue $1

case $1 in
	'--add')
		createUpdateUser $@
		;;
	'--update')
		createUpdateUser $@
		;;
	'--delete')
		deleteUser $@
		;;
	'--list')
		awk -F\: '/:/ {print $1}' $passFile
		;;
	*)
		echo "Did not recognize values"
		svnuserOptions
		;;
esac



	


