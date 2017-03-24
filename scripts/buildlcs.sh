#!/bin/sh

### PATHS ###
deployRoot="/d/liferay/portal/dxp-7.0"
gitLCSRoot="/d/git/lcs"
gitPortalRoot="/d/git/ee-7.0/portal/modules"


### CLEAN ###
if [ "$1" == "-c" ] || [ "$1" == "--clean" ] ; then
	echo "Deleting /deploy"
	cd $deployRoot"/deploy"
	exec & rm -rf *

	echo "Deleting /osgi/modules"
	cd $deployRoot"/osgi/modules"
	exec & rm -rf *

	echo "Deleting /osgi/state"
	cd $deployRoot"/osgi/state"
	exec & rm -rf *

	echo "Deleting /osgi/war"
	cd $deployRoot"/osgi/war"
	exec & rm -rf *

	echo "Deleting /tomcat-8.0.32/temp"
	cd $deployRoot"/tomcat-8.0.32/temp"
	exec & rm -rf *

	echo "Deleting /tomcat-8.0.32/work"
	cd $deployRoot"/tomcat-8.0.32/work"
	exec & rm -rf *

	echo "Deleting /work"
	cd $deployRoot"/work"
	exec & rm -rf *
fi


### PORTAL MODULES ####
privateApps=$gitPortalRoot"/private/apps"

lcs=$privateApps"/lcs"

cd $lcs"/lcs-api"
exec & gradle deploy

cd $lcs"/lcs-portlet"
exec & gradle deploy

oauth=$privateApps"/oauth"

cd $oauth"/oauth-api"
exec & gradle deploy

cd $oauth"/oauth-service"
exec & gradle deploy

petra=$gitPortalRoot"/apps/foundation/petra/petra-json-web-service-client"

cd $petra
exec & gradle deploy


### OSB LCS MODULES ####
cd $gitLCSRoot"/osb-lcs-admin"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-api"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-cache"
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

# cd $gitLCSRoot"osb-lcs-qa"
# exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-queue"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-report"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-service"
exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-taglib"
exec & gradle deploy

# cd $gitLCSRoot"/osb-lcs-test"
# exec & gradle deploy

cd $gitLCSRoot"/osb-lcs-theme"
exec & gulp deploy

cd $gitLCSRoot"/osb-lcs-web"
exec & gradle deploy


### DIAGNOSE ERRORS ###
## show status of all modules
exec & blade sh ss | grep lcs

## show if there are any dependencies issues
exec & blade sh dm | grep unavailable