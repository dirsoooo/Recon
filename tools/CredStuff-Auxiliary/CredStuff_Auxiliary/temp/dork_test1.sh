SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
python3 $SCRIPTPATH/tools/CredStuff-Auxiliary/CredStuff_Auxiliary/googler/googler site:throwbin.io OR site:pastebin.com OR site:cdn-*anonfiles.com AND intext:@target.com --count 100 --unfilter
