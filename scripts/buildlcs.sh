#!/bin/sh

### PATHS ###
deployRoot="/d/liferay/portal/dxp-7.0"
gitLCSRoot="/d/git/lcs"
gitMonitorRoot="/d/git/internship/team-assignments/monitor"
gitPortalRoot="/d/git/ee-7.0/portal/modules"

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

### OSB LCS MODULES ###
cd $gitLCSRoot"/osb-lcs-admin-web"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-api"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-cache"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-keystore"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-lang"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-nosql"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-nosql-api"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-nosql-service"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-nosql-service-activator"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-queue"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-report"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-service"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-taglib"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-theme"
exec & gulp deploy

cd $gitLCSRoot"/osb-lcs-web"
exec & gradle deploy

### MONITOR MODULES ####
cd $gitMonitorRoot"/monitor-singular-web"
exec & gradle deploy

cd $gitMonitorRoot"/monitor-theme"
exec & gulp deploy

### PORTAL MODULES ####
privateApps=$gitPortalRoot"/private/apps"

oauth=$privateApps"/oauth"

cd $oauth"/oauth-api"
exec & gradle deploy

cd $oauth"/oauth-service"
exec & gradle deploy

lcs=$privateApps"/lcs"

cd $lcs"/lcs-messaging"
exec & gradle deploy

cd $lcs"/lcs-portlet"
exec & gradle deploy

cd $lcs"/lcs-security"
exec & gradle deploy

## lcs-api and petra should be built last, to override deployed modules from dependency definitions in build.gradles. Awesome!
cd $lcs"/lcs-api"
exec & gradle deploy

cd $gitPortalRoot"/apps/foundation/petra/petra-json-web-service-client"
exec & gradle deploy