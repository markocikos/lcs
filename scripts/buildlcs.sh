#!/bin/sh

### PATHS ###
deployRoot="/d/liferay/portal/dxp-7.0"
gitLCSRoot="/d/git/lcs"
gitPortalPrivateRoot="/d/git/7.0.x-private/portal"

deployTomcatHome=$deployRoot"/tomcat-8.0.32"

libsPath=$(pwd)"/lib"

### CLEAN ###
if [ -d $deployRoot"/deploy" ] ; then
	echo "Deleting /deploy"
	cd $deployRoot"/deploy"
	exec & rm -rf *
fi

if [ -d $deployRoot"/osgi/modules" ] ; then
	echo "Deleting /osgi/modules"
	cd $deployRoot"/osgi/modules"
	exec & rm -rf *
fi

if [ -d $deployRoot"/osgi/state" ] ; then
	echo "Deleting /osgi/state"
	cd $deployRoot"/osgi/state"
	exec & rm -rf *
fi

if [ -d $deployRoot"/osgi/war" ] ; then
	echo "Deleting /osgi/war"
	cd $deployRoot"/osgi/war"
	exec & rm -rf *
fi

if [ -d $deployTomcatHome"/temp" ] ; then
	echo "Deleting Tomcat temp"
	cd $deployTomcatHome"/temp"
	exec & rm -rf *
fi

if [ -d $deployTomcatHome"/work" ] ; then
	echo "Deleting Tomcat work"
	cd $deployTomcatHome"/work"
	exec & rm -rf *
fi

if [ -d $deployRoot"/work" ] ; then
	echo "Deleting /work"
	cd $deployRoot"/work"
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

exec & gradle deployOSBLCSModules

### LCS CLIENT ###
cd $gitPortalPrivateRoot"/modules/private/apps/lcs/lcs-portlet"

exec & gradle deploy