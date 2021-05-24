#!/bin/sh 
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
googler_call="python3 $SCRIPTPATH/googler/googler --noprompt"
anonfiles_search1="site:throwbin.io OR site:pastebin.com OR site:cdn-*anonfiles.com AND intext:@" 
anonfiles_search2=$anonfiles_search1$1
anonfiles_unfilter="--unfilter"
googler_count="--count $2"
echo $googler_call $anonfiles_search2 $googler_count $anonfiles_unfilter > $SCRIPTPATH/temp/dork_test1.sh
chmod +x $SCRIPTPATH/temp/dork_test1.sh
sh $SCRIPTPATH/temp/dork_test1.sh
