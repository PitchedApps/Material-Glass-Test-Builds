#!/bin/bash

#####################################
#   Substratum Overlay Builder      #
#   run with sh and full path to    #
#   assets/overlays directory       #
#              - Pitched Apps       #
#####################################

# $1    full package dir
# $2    framework dir
# $3	aapt type
# http://elinux.org/Android_aapt
# -M    AndroidManifest.xml dir
# -S    resource directory
# -I    add existing package to base
# -f    force overwrite of existing files
# -F    apk output file
# -v	verbose for debug
buildApk() {
	if [ -d "$1/res" ]; then
		name="$(basename "$1")"
		printf "\n%s\n" "$name"
		# compile and save error log to $result
		result="$("./packager/$3" p -M AndroidManifest.xml -S "${1}res" -I "$2" -f -F "builds/${name}.test.apk" 2>&1 > /dev/null)"
		if [ ! -z "${result// }" ] ; then
			echo "$result" # just so the logs show on Travis
			printf "~~~ %s ~~~\n\n%s\n\n" "$name" "$result" 1>&2 # print error and append package name
		fi
	fi
}

# $1	parent dir
main() {
	if [ -d builds ]; then # clean build dir
		rm -r builds
	fi
	mkdir builds
	
	# get proper aapt version
	# http://stackoverflow.com/a/8597411
	if [[ "$OSTYPE" == "linux-gnu" ]]; then
		# linux-gnu
		aapt=aapt
	elif [[ "$OSTYPE" == "cygwin" ]]; then
		# POSIX compatibility layer and Linux environment emulation for Windows
		aapt=aapt.exe
	elif [[ "$OSTYPE" == "msys" ]]; then
		# Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
		aapt=aapt.exe
	else
		printf "Unsupported OS type" 1>&2
		exit 1
	fi						
	printf "AAPT: %s\nBuilding overlays...\n" "$aapt"
	for f in $1/*/; do 
		buildApk "$f" "./frameworks/n-lineage-nexus-5.apk" $aapt 2>> builds/log.txt
	done
}

main "$@"