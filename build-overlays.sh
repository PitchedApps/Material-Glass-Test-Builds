#!/bin/bash

#####################################
#	Substratum Overlay Builder	    #
#	run with sh and full path to    #
#	assets/overlays directory 	    #
#				- Pitched Apps	    #
#####################################

# $1    full package dir
# $2    framework dir
# http://elinux.org/Android_aapt
# -M    AndroidManifest.xml dir
# -S    resource directory
# -I    add existing package to base
# -f    force overwrite of existing files
# -F    apk output file
# -v	verbose for debug
function buildApk() {
	if [ -d "$1/res" ]; then
		name=`basename $1`
		# compile and save error log to $result
		result="$(./aapt.exe p -M AndroidManifest.xml -S ${1}res -I $2 -f -F builds/${name}.test.apk 2>&1 > /dev/null)"
		if [ ! -z "${result// }" ] ; then
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
	for f in $1/*/; do 
		buildApk $f "./frameworks/n-lineage-nexus-5.apk" &>> builds/log.txt
	done
}

main "$@"