#!/bin/sh

### PATHS ###
deployRoot="/d/liferay/portal/dxp-7.0"
gitLCSRoot="/d/git/lcs"
gitPortalPrivateRoot="/d/git/ee-7.0/portal"

deployTomcatHome=$deployRoot"/tomcat-8.0.32"

libsPath=$(pwd)"/lib"

### CLEAN ###
if [ -d $deployRoot"/deploy" ] ; then
	echo "Deleting "$deployRoot"/deploy"
	cd $deployRoot"/deploy"
	exec & rm -rf *
fi

if [ -d $deployRoot"/osgi/modules" ] ; then
	echo "Deleting "$deployRoot"/osgi/modules"
	cd $deployRoot"/osgi/modules"
	exec & rm -rf *
fi

if [ -d $deployRoot"/osgi/state" ] ; then
	echo "Deleting "$deployRoot"/osgi/state"
	cd $deployRoot"/osgi/state"
	exec & rm -rf *
fi

if [ -d $deployRoot"/osgi/war" ] ; then
	echo "Deleting "$deployRoot"/osgi/war"
	cd $deployRoot"/osgi/war"
	exec & rm -rf *
fi

if [ -d $deployTomcatHome"/temp" ] ; then
	echo "Deleting "$deployTomcatHome"/temp"
	cd $deployTomcatHome"/temp"
	exec & rm -rf *
fi

if [ -d $deployTomcatHome"/work" ] ; then
	echo "Deleting "$deployTomcatHome"/work"
	cd $deployTomcatHome"/work"
	exec & rm -rf *
fi

if [ -d $deployRoot"/work" ] ; then
	echo "Deleting "$deployRoot"/work"
	cd $deployRoot"/work"
	exec & rm -rf *
fi

if [ -d $deployRoot"/logs" ] ; then
	echo "Deleting "$deployRoot"/logs"
	cd $deployRoot"/logs"
	exec & rm -rf *
fi

### MYSQL ###
if [ ! -f $deployTomcatHome"/lib/ext/mysql.jar" ] ; then
	echo "ERROR - mysql.jar does not exist in Tomcat lib"

	if [ -f $libsPath"/mysql.jar" ] ; then
		echo "Copying mysql.jar to Tomcat"
		cp $libsPath"/mysql.jar" $deployTomcatHome"/lib/ext/"
	fi
fi

### LCS PLATFORM MODULES ###
cd $gitLCSRoot

exec & gradle clean idea deployOSBLCSModules

### LCS CLIENT ###
cd $gitPortalPrivateRoot"/modules/private/apps/lcs/lcs-portlet"

exec & gradle clean deploy