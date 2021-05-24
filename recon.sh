#!/usr/bin/env bash

#  /$$                           /$$$$$$     /$$$$$$$  /$$                                                            
# | $$                         /$$$__  $$$  | $$__  $$|__/                                                            
# | $$$$$$$  /$$   /$$        /$$_/  \_  $$ | $$  \ $$ /$$  /$$$$$$   /$$$$$$$  /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$ 
# | $$__  $$| $$  | $$       /$$/ /$$$$$  $$| $$  | $$| $$ /$$__  $$ /$$_____/ /$$__  $$ /$$__  $$ /$$__  $$ /$$__  $$
# | $$  \ $$| $$  | $$      | $$ /$$  $$| $$| $$  | $$| $$| $$  \__/|  $$$$$$ | $$  \ $$| $$  \ $$| $$  \ $$| $$  \ $$
# | $$  | $$| $$  | $$      | $$| $$\ $$| $$| $$  | $$| $$| $$       \____  $$| $$  | $$| $$  | $$| $$  | $$| $$  | $$
# | $$$$$$$/|  $$$$$$$      | $$|  $$$$$$$$/| $$$$$$$/| $$| $$       /$$$$$$$/|  $$$$$$/|  $$$$$$/|  $$$$$$/|  $$$$$$/
# |_______/  \____  $$      |  $$\________/ |_______/ |__/|__/      |_______/  \______/  \______/  \______/  \______/ 
#            /$$  | $$       \  $$$   /$$$                                                                            
#           |  $$$$$$/        \_  $$$$$$_/                                                                            
#            \______/           \______/                                                                                                 

# +-+-+-+-+-+-+
# |A|r|r|a|y|s|
# +-+-+-+-+-+-+

open_redir_parameters=(
	'?next='
	'?url='
	'?target='
	'?rurl='
	'?dest='
	'?destination='
	'?redir='
	'?redirect_uri='
	'?redirect_url='
	'?redirect='
	'/redirect/'
	'/cgi-bin/redirect.cgi?'
	'/out/'
	'/out?'
	'?view='
	'/login?to='
	'?image_url='
	'?go='
	'?return='
	'?returnTo='
	'?return_to='
	'?checkout_url='
	'?continue='
	'?return_path='
	'inurl:wp-content/uploads/ intitle:logs'
)

rce_parameters=(
	'?cmd='
	'?exec='
	'?command='
	'?execute'
	'?ping='
	'?query='
	'?jump='
	'?code='
	'?reg='
	'?do='
	'?func='
	'?arg='
	'?option='
	'?load='
	'?process='
	'?step='
	'?read='
	'?function='
	'?req='
	'?feature='
	'?exe='
	'?module='
	'?payload='
	'?run='
	'?print='

)

lfi_parameters=(
	'?cat='
	'?dir='
	'?action='
	'?board='
	'?date='
	'?detail='
	'?file='
	'?download='
	'?path='
	'?folder='
	'?prefix='
	'?include='
	'?page='
	'?inc='
	'?locate='
	'?show='
	'?doc='
	'?site='
	'?type='
	'?view='
	'?content='
	'?document='
	'?layout='
	'?mod='
	'?conf='

)

printBanner() {
	echo -e "\033[1;32m
	██▀███  ▓█████  ▄████▄   ▒█████   ███▄    █ 
	▓██ ▒ ██▒▓█   ▀ ▒██▀ ▀█  ▒██▒  ██▒ ██ ▀█   █ 
	▓██ ░▄█ ▒▒███   ▒▓█    ▄ ▒██░  ██▒▓██  ▀█ ██▒
	▒██▀▀█▄  ▒▓█  ▄ ▒▓▓▄ ▄██▒▒██   ██░▓██▒  ▐▌██▒
	░██▓ ▒██▒░▒████▒▒ ▓███▀ ░░ ████▓▒░▒██░   ▓██░
	░ ▒▓ ░▒▓░░░ ▒░ ░░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒ 
	░▒ ░ ▒░ ░ ░  ░  ░  ▒     ░ ▒ ▒░ ░ ░░   ░ ▒░
	░░   ░    ░   ░        ░ ░ ░ ▒     ░   ░ ░ 
	░        ░  ░░ ░          ░ ░           ░ 
	░                                                                                                         
		Crafted with <3 by Dirso \033[33mv1.0	

\033[1;35m\tBased on The Bug Hunters Methodology v4.0.2 By @Jhaddix	
\t    and recon of recon, tips and tricks by @ofjaaah
	\033[m"
}


show_help() {
	echo -e "\n\tUsage: \033[1;32m./recon.sh \033[35m[ -d domain ]\033[36m [ -w wordlist.txt ]\033[33m [ -gt GitHub-API_KEY ] \033[33m [ -st Shodan-API_KEY ]\033[m [ -q ] [ -f ]"
	echo -e "\n\t-d  | (required) : Your \033[1;35mtarget\033[m"
	echo -e "\t-w  | (required) : Path to your \033[1;36mwordlist\033[m"
	echo -e "\t-q  | (optional) : Quiet mode"
	echo -e "\t-o  | (optional) : Output folder. Default is in the script's location folder"
	echo -e "\t-f  | (optional) : Enable Fuzzing mode."
	echo -e "\n\t\033[33m[!] API_KEYS. Failing to pass your API Keys means that scans that need the key will be skipped\033[m"
	echo -e "\t-g  | (optional) : Your GitHub \033[1;33mAPI_KEY\033[m"
	echo -e "\t-s  | (optional) : Your Shodan \033[1;33mAPI_KEY\033[31m (Needs premium API Key)\033[m"
}


grepVuln() {
	for i in $1[@]; do
		if [ "$2" != "" ]; then
			if [ "$QUIET" != "True" ]; then
				echo $2 | grep "$i" | tee -a $3
			else
				echo $2 | grep "$i" >> $3
			fi
		fi
	done
}


wafDetect() {
	if [ "$(cat $1 | wc -l)" -ge "1" ] && [ "$1" != "" ]; then
		if [ "$QUIET" == "True" ];then
			echo -e -n "\033[1;36m[+] WAF Detect 🔎\033[m"
			wafw00f -i $1 -a -o $OUTFOLDER/subdomains/waf.txt > /dev/null
			echo " ✅"
		else
			echo -e "\033[1;32m
			░█░█░█▀█░█▀▀░░░█▀▄░█▀▀░▀█▀░█▀▀░█▀▀░▀█▀
			░█▄█░█▀█░█▀▀░░░█░█░█▀▀░░█░░█▀▀░█░░░░█░
			░▀░▀░▀░▀░▀░░░░░▀▀░░▀▀▀░░▀░░▀▀▀░▀▀▀░░▀░
			\033[m"
			wafw00f -i $1 -a -o $OUTFOLDER/subdomains/waf.txt
		fi
	fi
}


organizeDomains() {
	domains="$1"
	LDOUT="$2/level-domains.txt"
	if [ -r "$domains" ] && [ "$(cat $domains | wc -l)" -ge "1" ]; then
		echo -e "\033[35m[+] Organizing your domains 😊\033[m"
		if [ "$QUIET" != "True" ]; then
			echo -e "\n\033[1;32m[+]Finding 2nd level domains...\033[m"
		fi
		echo -e "[+]Finding 2nd level domains..." >>  $LDOUT
		if [ "$QUIET" != "True" ]; then
			cat $DOMAINS | grep -P '^(?:[a-z0-9]+\.){1}[^.]*$' | tee -a $LDOUT
		else
			cat $DOMAINS | grep -P '^(?:[a-z0-9]+\.){1}[^.]*$' >> $LDOUT
		fi
		if [ "$QUIET" != "True" ]; then
			echo -e "\n\033[1;32m[+]Finding 3rd level domains...\033[m"
		fi
		echo "[+]Finding 3rd level domains..." >> $LDOUT
		if [ "$QUIET" != "True" ]; then
			cat $DOMAINS | grep -P '^(?:[a-z0-9]+\.){2}[^.]*$' | tee -a $LDOUT
		else
			cat $DOMAINS | grep -P '^(?:[a-z0-9]+\.){2}[^.]*$' >> $LDOUT
		fi
		if [ "$QUIET" != "True" ]; then
			echo -e "\n\033[1;32m[+] Finding 4th level dodmains or higher\033[m"
		fi
		echo "[+] Finding 4th level dodmains or higher" >> $LDOUT
		if [ "$QUIET" != "True" ]; then
			cat $DOMAINS | grep -P '^(?:[a-z0-9]+\.){3,}[^.]*$' | tee -a $LDOUT
		else
			cat $DOMAINS | grep -P '^(?:[a-z0-9]+\.){3,}[^.]*$' >> $LDOUT
		fi
		echo -e "\033[32m[!] Done. Output saved in $LDOUT\033[m"
	fi
}


asnEnum() {
	subdomain="$1"
	output_folder="$2"
	[[ ! -d $output_folder ]] && mkdir $output_folder 2>/dev/null
	org="$(echo $domain | cut -d '.' -f1)"
	if [ $"$QUIET" != "True" ]; then
		echo -e "\033[1;32m
		░█▀█░█▀▀░█▀█░░░█▀▀░█▀█░█░█░█▄█░█▀▀░█▀▄░█▀█░▀█▀░▀█▀░█▀█░█▀█
		░█▀█░▀▀█░█░█░░░█▀▀░█░█░█░█░█░█░█▀▀░█▀▄░█▀█░░█░░░█░░█░█░█░█
		░▀░▀░▀▀▀░▀░▀░░░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀
		\033[m"
		echo $org | metabigor net --org -o $output_folder/$org.txt
	else
		echo -e -n "\n\033[1;36m[+] ASN Enumeration 🔎\033[m"
		echo $org | metabigor net --org >> $output_folder/$org.txt
		echo " ✅"
	fi
	if [[ -e $output_folder/$org.txt ]]; then
		sort -u $output_folder/$org.txt -o $output_folder/$org.txt
		asns="$(cat $output_folder/$org.txt | wc -l)"
		echo -e "\n\033[1;32m[!] Found \033[1;31m$asns\033[1;32m ASNs\033[m"
	else
		echo -e "\n\033[1;32m[!] Found \033[1;31m0\033[1;32m ASNs\033[m"
	fi
}


checkActive() {
	subdomains="$1"
	output_folder="$2"
	if [ "$(cat $subdomains | wc -l)" -ge "1" ]; then
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█▀█░█▀▀░▀█▀░▀█▀░█░█░█▀▀░░░█▀▄░█▀█░█▄█░█▀█░▀█▀░█▀█░█▀▀
			░█▀█░█░░░░█░░░█░░▀▄▀░█▀▀░░░█░█░█░█░█░█░█▀█░░█░░█░█░▀▀█
			░▀░▀░▀▀▀░░▀░░▀▀▀░░▀░░▀▀▀░░░▀▀░░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀▀
			\033[m"
			cat $subdomains | httprobe | tee -a $output_folder/alive.txt
			cat $subdomains | httpx --silent --threads 300 | tee -a $output_folder/alive.txt
		else
			echo -e "\n\033[1;36m[+] Active Domains 🔎\033[m"
			cat $subdomains | httprobe >> $output_folder/alive.txt
			cat $subdomains | httpx --silent --threads 300 >> $output_folder/alive.txt
		fi
		sort -u $output_folder/alive.txt -o $output_folder/alive.txt
	fi
}


subdomainEnumeration() {
	target="$1"
	output_folder="$2"
	if [ -n "$target" ] && [ -n "$output_folder" ]; then
		[[ ! -d $output_folder ]] && mkdir $output_folder 2>/dev/null
		[[ ! -d $output_folder/knockpy/ ]] && mkdir $output_folder/knockpy/ 2>/dev/null
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█▀▀░█░█░█▀▄░░░█▀▀░█▀█░█░█░█▄█
			░▀▀█░█░█░█▀▄░░░█▀▀░█░█░█░█░█░█
			░▀▀▀░▀▀▀░▀▀░░░░▀▀▀░▀░▀░▀▀▀░▀░▀
			\033[m"
			echo -e "\033[33m[!] All subdomains will be saved in \033[1;31m$output_folder/subdomains.txt\033[m"
			echo -e "\033[36m>>>\033[35m Running assetfinder 🔍\033[m"
			assetfinder $target | tee -a $output_folder/subdomains.txt || $GOPATH/bin/assetfinder $target | tee -a $output_folder/subdomains.txt
			echo -e "\n\033[36m>>>\033[35m Running subfinder 🔍\033[m"
			subfinder --silent -d $target | tee -a $output_folder/subdomains.txt || $GOPATH/bin/subfinder --silent -d $target | tee -a $output_folder/subdomains.txt
			echo -e "\n\033[36m>>>\033[35m Running amass 🔍\033[m"
			amass enum --passive -d $target | tee -a $output_folder/subdomains.txt || $GOPATH/bin/amass enum --passive -d $target | tee -a $output_folder/subdomains.txt
			echo -e "\n\033[36m>>>\033[35m Getting Subdomains from RapidDNS.io 🔍\033[m"
			curl -s "https://rapiddns.io/subdomain/$target?full=1#result" | grep "<td><a" | cut -d '"' -f 2 | grep http | cut -d '/' -f3 | sed 's/#results//g' | sort -u | tee -a $output_folder/subdomains.txt
			echo -e "\n\033[36m>>>\033[35m Getting Subdomains from Riddler.io 🔍\033[m"
			curl -s "https://riddler.io/search/exportcsv?q=pld:$target" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | tee -a $output_folder/subdomains.txt
			echo -e "\n\033[36m>>>\033[35m Getting Subdomains from SecurityTrails 🔍\033[m"
			curl -s "https://securitytrails.com/list/apex_domain/$domain" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | grep ".$domain" | sort -u | tee -a $output_folder/subdomains.txt
			echo -e "\n\033[36m>>>\033[35m Running findomain 🔍\033[m"
			findomain -q --target $target | tee -a $output_folder/subdomains.txt || $GOPATH/bin/findomain -q --target $target | tee -a $output_folder/subdomains.txt
			echo -e "\n\033[36m>>>\033[35m Running SubDomainizer 🔍\033[m"
			python3 $SCRIPTPATH/tools/SubDomainizer.py -u $target -o $SCRIPTPATH/SubDomainizer$domain.txt | tee $OUTFOLDER/SubDomainizer-$domain.txt
			echo -e "\n\033[36m>>>\033[35m Running sublist3r 🔍\033[m"
			sublist3r -d $target -o $SCRIPTPATH/sublist3r-$domain.txt
			cat $SCRIPTPATH/sublist3r-$domain.txt >> $output_folder/subdomains.txt
			rm $SCRIPTPATH/sublist3r-$domain.txt
			knockpy $target -w $wordlist -o $output_folder/knockpy/ -t 5
			if [ "$GHAPIKEY" != "False" ]; then
				echo -e "\n\033[36m>>>\033[35m Running Github-Subdomains 🔍\033[m"
				python3 $SCRIPTPATH/tools/github-search/github-subdomains.py -t $GHAPIKEY -d $target | tee -a $output_folder/subdomains.txt
				cat $output_folder/subdomains.txt | grep -v ">>>*" | grep -v "\*" >> $SCRIPTPATH/subs_$domain.txt
				rm $output_folder/subdomains.txt
				mv $SCRIPTPATH/subs_$domain.txt $output_folder/subdomains.txt
			fi
		else
			echo -e "\n\033[1;36m[+] Subdomain Enumeration 🔎\033[m"
			echo -e "\033[33m[!] All subdomains will be saved in \033[1;31m$output_folder/subdomains.txt\033[m"
			echo -e -n "\033[36m>>>\033[35m Running assetfinder 🔍\033[m"
			assetfinder $target >> $output_folder/subdomains.txt || $GOPATH/bin/assetfinder $target >> $output_folder/subdomains.txt
			echo " ✅"
			echo -e -n "\033[36m>>>\033[35m Running subfinder 🔍\033[m"
			subfinder --silent -d $target >> $output_folder/subdomains.txt || $GOPATH/bin/subfinder --silent -d $target >> $output_folder/subdomains.txt
			echo " ✅"
			echo -e -n "\033[36m>>>\033[35m Running amass 🔍\033[m"
			amass enum --passive -d $target >> $output_folder/subdomains.txt || $GOPATH/bin/amass enum --passive -d $target >> $output_folder/subdomains.txt
			echo " ✅"
			echo -e -n "\033[36m>>>\033[35m Getting Subdomains from RapidDNS.io 🔍\033[m"
			curl -s "https://rapiddns.io/subdomain/$target?full=1#result" | grep "<td><a" | cut -d '"' -f 2 | grep http | cut -d '/' -f3 | sed 's/#results//g' | sort -u >> $output_folder/subdomains.txt
			echo " ✅"
			echo -e -n "\033[36m>>>\033[35m Getting Subdomains from Riddler.io 🔍\033[m"
			curl -s "https://riddler.io/search/exportcsv?q=pld:$target" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u >> $output_folder/subdomains.txt
			echo " ✅"
			echo -e -n "\033[36m>>>\033[35m Getting Subdomains from SecurityTrails 🔍\033[m"
			curl -s "https://securitytrails.com/list/apex_domain/$domain" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | grep ".$domain" | sort -u >> $output_folder/subdomains.txt
			echo " ✅"
			echo -e -n "\033[36m>>>\033[35m Running findomain 🔍\033[m"
			findomain -q --target $target >> $output_folder/subdomains.txt || $GOPATH/bin/findomain -q --target $target >> $output_folder/subdomains.txt
			echo " ✅"
			echo -e -n "\033[36m>>>\033[35m Running SubDomainizer 🔍\033[m"
			python3 $SCRIPTPATH/tools/SubDomainizer.py -u $target -o $SCRIPTPATH/SubDomainizer$domain.txt >> $OUTFOLDER/subdomains/SubDomainizer-$domain.txt
			echo " ✅"
			echo -e -n "\n\033[36m>>>\033[35m Running sublist3r 🔍\033[m"
			sublist3r -d $target -o $SCRIPTPATH/sublist3r-$domain.txt > $SCRIPTPATH/temp.txt
			cat $SCRIPTPATH/sublist3r-$domain.txt >> $output_folder/subdomains.txt
			rm $SCRIPTPATH/sublist3r-$domain.txt
			rm $SCRIPTPATH/temp.txt
			echo " ✅"
			echo -e -n "\n\033[36m>>>\033[35m Running Knockpy 🔍\033[m"
			knockpy $target -w $wordlist -o $output_folder/knockpy/ -t 5 > $SCRIPTPATH/knocktemp
			rm $SCRIPTPATH/knocktemp
			echo " ✅"
			if [ "$GHAPIKEY" != "False" ]; then
				echo -e -n "\033[36m>>>\033[35m Running Github-Subdomains 🔍\033[m"
				python3 $SCRIPTPATH/tools/github-search/github-subdomains.py -t $GHAPIKEY -d $target >> $output_folder/subdomains.txt
				cat $output_folder/subdomains.txt | grep -v ">>>*" | grep -v "\*" >> $SCRIPTPATH/subs_$domain.txt
				rm $output_folder/subdomains.txt
				mv $SCRIPTPATH/subs_$domain.txt $output_folder/subdomains.txt
				echo " ✅"
			fi
		fi
		cat $SCRIPTPATH/SubDomainizer$domain.txt >> $output_folder/subdomains.txt
		rm $SCRIPTPATH/SubDomainizer$domain.txt
		for a in $(ls $output_folder/knockpy/*); do
			python3 $SCRIPTPATH/scripts/knocktofile.py -f $a -o $SCRIPTPATH/knock.txt
		done
		cat $SCRIPTPATH/knock.txt >> $output_folder/subdomains.txt
		rm $SCRIPTPATH/knock.txt
		sort -u $output_folder/subdomains.txt -o $output_folder/subdomains.txt
		cat $output_folder/subdomains.txt | grep -v "\*" >> $SCRIPTPATH/temporary.txt
		cat $SCRIPTPATH/temporary.txt | grep -v "[-] error occurred: HTTPSConnectionPool(host=raw.githubusercontent.com, port=443): Read timed out. (read timeout=5)" >> $SCRIPTPATH/temporary2.txt
		rm $SCRIPTPATH/temporary.txt
		mv $SCRIPTPATH/temporary2.txt $output_folder/subdomains.txt
	fi
	uniq="$(cat $output_folder/subdomains.txt | wc -l)"
	echo -e "\n\033[1;32m[!] Found \033[1;31m$uniq\033[1;32m subdomains\033[m"
}


subdomainTakeover() {
	list="$1"
	output_folder="$2"
	if [ "$(cat $list | wc -l)" -ge "1" ]; then
		[[ ! -d $output_folder ]] && mkdir $output_folder
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█▀▀░█░█░█▀▄░░░▀█▀░█▀█░█░█░█▀▀░█▀█░█░█░█▀▀░█▀▄
			░▀▀█░█░█░█▀▄░░░░█░░█▀█░█▀▄░█▀▀░█░█░▀▄▀░█▀▀░█▀▄
			░▀▀▀░▀▀▀░▀▀░░░░░▀░░▀░▀░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀
			\033[m"
		else
			echo -e "\n\033[1;36m[+] Subdomain Takeover 🔎\033[m"
		fi
		subjack -w $list -t 100 -timeout 30 -o $output_folder/takeover.txt -ssl || $GOPATH/bin/subjack -w $list -t 100 -timeout 30 -o $output_folder/takeover.txt -ssl
		if [ -f "$output_folder/takeover.txt" ]; then
			stofound="$(cat $output_folder/takeover.txt | wc -l)"
			echo -e "\033[32m[+] $stofound vulnerable domains were found\033[m"
		else	
			echo -e "\033[31m[-] There is no domain vulnerable to Subdomain Takeover\033[m"
		fi
	fi
}


dnsLookup() {
	domains="$1"
	output_folder="$2"
	[[ ! -d $output_folder/DNS ]] && mkdir $output_folder/DNS
	if [ "$(cat $domains | wc -l)" -ge "1" ]; then
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█▀▄░█▀█░█▀▀░░░█░░░█▀█░█▀█░█░█░█░█░█▀█
			░█░█░█░█░▀▀█░░░█░░░█░█░█░█░█▀▄░█░█░█▀▀
			░▀▀░░▀░▀░▀▀▀░░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░░
			\033[m"
			echo -e "\033[36m>>>\033[35m Discovering IPs 🔍\033[32m"
			dnsx --silent -l $domains -resp -o $output_folder/DNS/dns.txt || $GOPATH/bin/dnsx -l $DOMAINS -resp -o $output_folder/DNS/dns.txt
			echo -e "\033[m"
			echo -e "\033[36m>>>\033[35m DNS enumeration 🔍\033[m"
			dnsrecon -d $domain -D $wordlist | tee -a $output_folder/DNS/dnsrecon.txt
			dnsenum $domain -f $wordlist -o $output_folder/DNS/dnsenum.xml
		else
			echo -e "\n\033[1;36m[+] DNS Lookup 🔎\033[m"
			echo -e -n "\033[36m>>>\033[35m Discovering IPs 🔍\033[m"
			dnsx --silent -l $domains -resp -o $output_folder/DNS/dns.txt > $SCRIPTPATH/temp || $GOPATH/bin/dnsx --silent -l $domains -resp -o $output_folder/DNS/dns.txt > $SCRIPTPATH/temp
			rm $SCRIPTPATH/temp
			echo " ✅"
			echo -e -n "\033[36m>>>\033[35m DNS enumeration 🔍\033[m"
			dnsrecon -d $domain -D $wordlist >> $output_folder/DNS/dnsrecon.txt 2>/dev/null > $SCRIPTPATH/temp1
			rm $SCRIPTPATH/temp1
			dnsenum $domain -f $wordlist -o $output_folder/DNS/dnsenum.xml 2>/dev/null > $SCRIPTPATH/temp2
			rm $SCRIPTPATH/temp2
			echo " ✅"
		fi
		cat $output_folder/DNS/dns.txt | awk '{print $2}' | tr -d "[]" >> $output_folder/DNS/ip_only.txt
		if [ -e $output_folder/DNS/ip_only.txt ]; then
			ipfound="$(cat $output_folder/DNS/ip_only.txt | wc -l)"
			echo -e "\033[35m[+] Found \033[31m$ipfound\033[35m IPs\033[m"
		fi
		rm $SCRIPTPATH/$domain\_ips.txt
	fi
}


favAnalysis() {
	alive_domains="$1"
	output_folder="$2"
	FAVOUT="$output_folder/favfreak"
	if [ "$(cat $alive_domains | wc -l)" -ge "1" ]; then
		[[ ! -d $output_folder ]] && mkdir $output_folder
		[[ ! -d $FAVOUT ]] && mkdir $FAVOUT
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█▀▀░█▀█░█░█░▀█▀░█▀▀░█▀█░█▀█░░░█▀█░█▀█░█▀█░█░░░█░█░█▀▀░▀█▀░█▀▀
			░█▀▀░█▀█░▀▄▀░░█░░█░░░█░█░█░█░░░█▀█░█░█░█▀█░█░░░░█░░▀▀█░░█░░▀▀█
			░▀░░░▀░▀░░▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░░░▀░▀░▀░▀░▀░▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀
			\033[m"
			cat $alive_domains | python3 $SCRIPTPATH/tools/FavFreak/favfreak.py --shodan -o $FAVOUT
		else
			echo -e "\n\033[1;36m[+] Favicon Analysis 🔎\033[m"
			cat $alive_domains | python3 $SCRIPTPATH/tools/FavFreak/favfreak.py --shodan -o $FAVOUT > $SCRIPTPATH/tmpfavfreak
			rm $SCRIPTPATH/tmpfavfreak
		fi
		echo -e "\033[36m>>>\033[35m All hashes saved in \033[1;31m$output_folder/favfreak/*.txt\033[m"
		ORG="$(echo $domain | cut -d '.' -f1)"
		if [ "$SHODANAPIKEY" != "False" ]; then
			echo -e "\033[36m>>>\033[35m Searching for $domain assets in Shodan\033[m"
			shodan init $SHODANAPIKEY 2>/dev/null
			for hash in $(ls $FAVOUT | cut -d '.' -f1); do
				shodan search org:"$ORG" http.favicon.hash:$hash --fields ip_str,port --separator " " | awk '{print $1":"$2}' | tee -a $output_folder/shodan-results.txt
			done
		fi
		echo -e "\033[33m[!] If you don't have the paid Shodan API Key you can do it manually!\033[m"
		echo -e "\033[32m[+] Shodan Dorks will be saved in \033[31m$output_folder/shodan-manual.txt\033[m"
		for a in $(ls $FAVOUT); do
			hash=$(echo "$a" | tr -d "$SCRIPTPATH" | tr -d '/abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' | tr -d '\' 2>/dev/null | cut -d '.' -f1 | sed -e 's/,//g')
			if [ "$QUIET" != "True" ]; then
				echo "org:"$ORG" http.favicon.hash:$hash" | tee -a $output_folder/shodan-manual.txt
			else
				echo "org:"$ORG" http.favicon.hash:$hash" >> $output_folder/shodan-manual.txt
			fi
		done
		if [ -e $output_folder/shodan-results.txt ]; then
			if [ "$(cat $output_folder/shodan-results.txt) | wc -l" == "0" ]; then
				rm $output_folder/shodan-results.txt
			fi
		fi
	fi
}


dirFuzz() {
	alive_domains_fuzz="$1"
	output_folder_fuzz="$2"
	if [ "$(cat $alive_domains_fuzz | wc -l)" -ge "1" ];then
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█▀▄░▀█▀░█▀▄░█▀▀░█▀▀░▀█▀░█▀█░█▀▄░█░█░░░█▀▀░█░█░▀▀█░▀▀█░▀█▀░█▀█░█▀▀
			░█░█░░█░░█▀▄░█▀▀░█░░░░█░░█░█░█▀▄░░█░░░░█▀▀░█░█░▄▀░░▄▀░░░█░░█░█░█░█
			░▀▀░░▀▀▀░▀░▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀░░▀░░░░▀░░░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀
			\033[m"
		else
			echo -e "\n\033[1;36m[+] Directory Fuzzing 🔎\033[m"
		fi
		[[ ! -d $output_folder_fuzz ]] && mkdir $output_folder_fuzz 2>/dev/null
		for d in $(cat $alive_domains_fuzz); do
			dnohttps="$(echo $d| cut -d "/" -f3-)"
			echo -e "\n\033[1;32m>>> Fuzzing $d\033[m"
			ffuf -u $d/FUZZ -w $wordlist -t 100 -sf -s | tee $output_folder_fuzz/$dnohttps
		done
	fi
}


googleHacking() {
	output_folder_googledorks="$1"
	if [ -n $output_folder_googledorks ]; then
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█▀▀░█▀█░█▀█░█▀▀░█░░░█▀▀░░░█░█░█▀█░█▀▀░█░█░▀█▀░█▀█░█▀▀
			░█░█░█░█░█░█░█░█░█░░░█▀▀░░░█▀█░█▀█░█░░░█▀▄░░█░░█░█░█░█
			░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░░░▀░▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀
			\033[m"
		else
			echo -e "\n\033[1;36m[+] Google Dorks 🔎\033[m"
		fi
		echo -e "\033[33m>> All results will be saved in $output_folder_googledorks/dorks.txt\033[m"
		[[ ! -d $OUTFOLDER/dorks ]] && mkdir $OUTFOLDER/dorks
		[[ ! -d $output_folder_googledorks ]] && mkdir $output_folder_googledorks 2>/dev/null
		echo "site:$domain intitle:'Web user login'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain intitle:'login' 'Are you a patient' 'eRAD'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain inurl:wp-content/uploads/ intitle:'logs'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain inurl:'/lib/editor/atto/plugins/managefiles/' | inurl:'calendar/view.php?view=month'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain intext:'password'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain filetype:sql ('values * MD5' | 'values * password' | 'values * encrypt')" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain inurl:Dashboard.jspa intext:'Atlassian Jira Project Management Software'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain 'SQL Server Driver][SQL Server]Line 1: Incorrect syntax near'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain 'Warning: mysql_connect(): Access denied for user: 'on line'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain filetype:sql 'insert into' (pass|passwd|password)" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain 'Warning: mysql_query()' 'invalid query'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain intitle:'Apache2 Ubuntu Default Page: It works'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain 'Your password is * Remember this for later use'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain intitle:index.of id_rsa -id_rsa.pub" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain allinurl:*.php?txtCodiInfo=" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain allinurl:auth_user_file.txt" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain filetype:sql +'IDENTIFIED BY' -cvs" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain allinurl:'exchange/logon.asp'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain allinurl:/examples/jsp/snp/snoop.jsp" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain intext:'admin credentials'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain allintitle:*.php?filename=*" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain inurl:8080/login" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain 'Index of' inurl:phpmyadmin" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain intitle:'index of' inurl:ftp" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain allintext:username filetype:log" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain 'index of' 'database.sql.zip'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain filetype:sql" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain intext:Index of /" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain intext:'database dump'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain filetype:log username putty" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain filetype:xls inurl:'email.xls'" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain intitle:'Index of' wp-admin" | tr "'" '"' >> $output_folder_googledorks/dorks.txt
		echo "site:$domain allintitle:*.php?logon=*" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain allintitle:*.php?page=*" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain allintitle:admin.php" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain allinurl: admin mdb" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain allinurl:'.r{}_vti_cnf/'"  | tr "'" '"'>> $output_folder_googledorks/dorks.txt
		echo "site:$domain filetype:sql password" >> $output_folder_googledorks/dorks.txt
		echo "site:$domain filetype:STM STM" >> $output_folder_googledorks/dorks.txt
	fi
}


ghDork() {
	out_ghdork="$1"
	if [ "$QUIET" != "True" ]; then
		echo -e "\033[1;32m
		░█▀▀░▀█▀░▀█▀░█░█░█░█░█▀▄░░░█▀▄░█▀█░█▀▄░█░█░█▀▀
		░█░█░░█░░░█░░█▀█░█░█░█▀▄░░░█░█░█░█░█▀▄░█▀▄░▀▀█
		░▀▀▀░▀▀▀░░▀░░▀░▀░▀▀▀░▀▀░░░░▀▀░░▀▀▀░▀░▀░▀░▀░▀▀▀
		\033[m"
	else
		echo -e "\n\033[1;36m[+] GitHub Dorks 🔎\033[m"
	fi
	echo -e "\033[33m>> All results will be saved in $out_ghdork/*\033[m"
	[[ ! -d $OUTFOLDER/dorks ]] && mkdir $OUTFOLDER/dorks
	[[ ! -d $out_ghdork ]] && mkdir $out_ghdork 2>/dev/null
	for a in $(cat $DOMAINS); do
		outdir="$out_ghdork/$a.txt"
		if [ "$(cat $DOMAINS | wc -l)" -ge "1" ]; then
			without_suffix=$(echo $a | cut -d . -f1)
			echo -e "$a" >> $outdir
			echo "************ Github Dork Links (must be logged in) *******************" >> $outdir
			echo "  password" >> $outdir
			echo "https://github.com/search?q=%22$a%22+password&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+password&type=Code" >> $outdir
			echo " npmrc _auth" >> $outdir
			echo "https://github.com/search?q=%22$a%22+npmrc%20_auth&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+npmrc%20_auth&type=Code" >> $outdir
			echo " dockercfg" >> $outdir
			echo "https://github.com/search?q=%22$a%22+dockercfg&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+dockercfg&type=Code" >> $outdir
			echo "  pem private" >> $outdir
			echo "https://github.com/search?q=%22$a%22+pem%20private&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+extension:pem%20private&type=Code" >> $outdir
			echo "  id_rsa" >> $outdir
			echo "https://github.com/search?q=%22$a%22+id_rsa&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+id_rsa&type=Code" >> $outdir
			echo " aws_access_key_id" >> $outdir
			echo "https://github.com/search?q=%22$a%22+aws_access_key_id&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+aws_access_key_id&type=Code" >> $outdir
			echo "  s3cfg" >> $outdir
			echo "https://github.com/search?q=%22$a%22+s3cfg&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+s3cfg&type=Code" >> $outdir
			echo " htpasswd" >> $outdir
			echo "https://github.com/search?q=%22$a%22+htpasswd&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+htpasswd&type=Code" >> $outdir
			echo " git-credentials" >> $outdir
			echo "https://github.com/search?q=%22$a%22+git-credentials&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+git-credentials&type=Code" >> $outdir
			echo " bashrc password" >> $outdir
			echo "https://github.com/search?q=%22$a%22+bashrc%20password&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+bashrc%20password&type=Code" >> $outdir
			echo " sshd_config" >> $outdir
			echo "https://github.com/search?q=%22$a%22+sshd_config&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+sshd_config&type=Code" >> $outdir
			echo " xoxp OR xoxb OR xoxa" >> $outdir
			echo "https://github.com/search?q=%22$a%22+xoxp%20OR%20xoxb%20OR%20xoxa&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+xoxp%20OR%20xoxb&type=Code" >> $outdir
			echo "  SECRET_KEY" >> $outdir
			echo "https://github.com/search?q=%22$a%22+SECRET_KEY&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+SECRET_KEY&type=Code" >> $outdir
			echo " client_secret" >> $outdir
			echo "https://github.com/search?q=%22$a%22+client_secret&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+client_secret&type=Code" >> $outdir
			echo " sshd_config" >> $outdir
			echo "https://github.com/search?q=%22$a%22+sshd_config&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+sshd_config&type=Code" >> $outdir
			echo " github_token" >> $outdir
			echo "https://github.com/search?q=%22$a%22+github_token&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+github_token&type=Code" >> $outdir
			echo "  api_key" >> $outdir
			echo "https://github.com/search?q=%22$a%22+api_key&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+api_key&type=Code" >> $outdir
			echo " FTP" >> $outdir
			echo "https://github.com/search?q=%22$a%22+FTP&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+FTP&type=Code" >> $outdir
			echo " app_secret" >> $outdir
			echo "https://github.com/search?q=%22$a%22+app_secret&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+app_secret&type=Code" >> $outdir
			echo "  passwd" >> $outdir
			echo "https://github.com/search?q=%22$a%22+passwd&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+passwd&type=Code" >> $outdir
			echo " s3.yml" >> $outdir
			echo "https://github.com/search?q=%22$a%22+.env&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+.env&type=Code" >> $outdir
			echo " .exs" >> $outdir
			echo "https://github.com/search?q=%22$a%22+.exs&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+.exs&type=Code" >> $outdir
			echo " beanstalkd.yml" >> $outdir
			echo "https://github.com/search?q=%22$a%22+beanstalkd.yml&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+beanstalkd.yml&type=Code" >> $outdir
			echo " deploy.rake" >> $outdir
			echo "https://github.com/search?q=%22$a%22+deploy.rake&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+deploy.rake&type=Code" >> $outdir
			echo " mysql" >> $outdir
			echo "https://github.com/search?q=%22$a%22+mysql&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+mysql&type=Code" >> $outdir
			echo " credentials" >> $outdir
			echo "https://github.com/search?q=%22$a%22+credentials&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+credentials&type=Code" >> $outdir
			echo "  PWD" >> $outdir
			echo "https://github.com/search?q=%22$a%22+PWD&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+PWD&type=Code" >> $outdir
			echo " deploy.rake" >> $outdir
			echo "https://github.com/search?q=%22$a%22+deploy.rake&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+deploy.rake&type=Code" >> $outdir
			echo " .bash_history" >> $outdir
			echo "https://github.com/search?q=%22$a%22+.bash_history&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+.bash_history&type=Code" >> $outdir
			echo " .sls" >> $outdir
			echo "https://github.com/search?q=%22$a%22+.sls&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+PWD&type=Code" >> $outdir
			echo " secrets" >> $outdir
			echo "https://github.com/search?q=%22$a%22+secrets&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+secrets&type=Code" >> $outdir
			echo " composer.json" >> $outdir
			echo "https://github.com/search?q=%22$a%22+composer.json&type=Code" >> $outdir
			echo "https://github.com/search?q=%22$without_suffix%22+composer.json&type=Code" >> $outdir
		fi
	done
	echo -e "\033[32m[+] Output saved in \033[31m$out_ghdork/*.txt\033[m"
	echo -e "\033[1;31m[!] Check the Dorks manually!\033[m"
}


credStuff() {
	len="$1"
	output_folder="$2"
	[[ ! -d $output_folder ]] && mkdir $output_folder
	[[ ! -d $output_folder/credstuff ]] && mkdir $output_folder/credstuff
	if [ "$domain" != "" ]; then
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█▀▀░█▀▄░█▀▀░█▀▄░░░█▀▀░▀█▀░█░█░█▀▀░█▀▀
			░█░░░█▀▄░█▀▀░█░█░░░▀▀█░░█░░█░█░█▀▀░█▀▀
			░▀▀▀░▀░▀░▀▀▀░▀▀░░░░▀▀▀░░▀░░▀▀▀░▀░░░▀░░
			\033[m"
			$SCRIPTPATH/tools/CredStuff-Auxiliary/CredStuff_Auxiliary/main.sh $domain $1 | tee -a $output_folder/credstuff/credstuff.txt
		else
			echo -e "\n\033[1;36m[+] Cred Stuff 🔎\033[m"
			$SCRIPTPATH/tools/CredStuff-Auxiliary/CredStuff_Auxiliary/main.sh $domain $1 >> $output_folder/credstuff/credstuff.txt
		fi
	fi
}


screenshots() {
	alive_domains_screenshots="$1"
	out_screenshots="$2"
	if [ -r $alive_domains_screenshots ]; then
		if [ "$(cat $alive_domains_screenshots | wc -l)" -ge "1" ]; then
			if [ "$QUIET" != "True" ]; then
				echo -e "\033[1;32m
				░█▀▀░█▀▀░█▀▄░█▀▀░█▀▀░█▀█░█▀▀░█░█░█▀█░▀█▀░█▀▀
				░▀▀█░█░░░█▀▄░█▀▀░█▀▀░█░█░▀▀█░█▀█░█░█░░█░░▀▀█
				░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░░▀░░▀▀▀
				\033[m"
			else
				echo -e "\n\033[1;36m[+] Screenshots 🔎\033[m"
			fi
			python3 $SCRIPTPATH/tools/EyeWitness/Python/EyeWitness.py --web --no-prompt -f $alive_domains_screenshots -d $out_screenshots --selenium-log-path $out_screenshots/selenium-log.txt --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
		fi
	fi
}


portscan() {
	portscan_domains="$1"
	ips="$2"
	output_folder="$3"
	if [ "$(cat $portscan_domains | wc -l)" -ge "1" ] && [ "$(cat $ips | wc -l)" -ge "1" ]; then
		[[ ! -d $Ooutput_folder ]] && mkdir $output_folder 2>/dev/null
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█▀█░█▀█░█▀▄░▀█▀░░░█▀▀░█▀▀░█▀█░█▀█
			░█▀▀░█░█░█▀▄░░█░░░░▀▀█░█░░░█▀█░█░█
			░▀░░░▀▀▀░▀░▀░░▀░░░░▀▀▀░▀▀▀░▀░▀░▀░▀
			\033[m"
			echo -e "\n\033[36m>>>\033[35m Running Nmap 🔍\033[m\n"
			nmap -iL $portscan_domains --top-ports 5000 --max-rate=50000 -oG $output_folder/nmap.txt
			echo -e "\n\033[36m>>>\033[35m Running Masscan 🔍\033[m\n"
			sudo masscan -p1-65535 -iL $ips --max-rate=50000 -oG $output_folder/masscan.txt
			echo -e "\n\033[36m>>>\033[35m Running Naabu 🔍\033[m\n"
			cat $portscan_domains | filter-resolved | cf-check | sort -u | naabu -rate 40000 -silent -verify | httprobe | tee -a $output_folder/naabu.txt
		else
			echo -e "\n\033[1;36m[+] Port Scan 🔎\033[m"
			echo -e -n "\n\033[36m>>>\033[35m Running Nmap 🔍\033[m\n"
			nmap -iL $portscan_domains --top-ports 5000 --max-rate=50000 -oG $output_folder/nmap.txt 2>/dev/null > $SCRIPTPATH/nmaptemp
			rm $SCRIPTPATH/nmaptemp
			echo "✅"
			echo -e "\n\033[36m>>>\033[35m Running Masscan 🔍\033[m\n"
			sudo masscan -p1-65535 -iL $ips --max-rate=50000 -oG $output_folder/masscan.txt > $SCRIPTPATH/masscantemp
			rm $SCRIPTPATH/masscantemp
			echo -e -n "\n\033[36m>>>\033[35m Running Naabu 🔍\033[m\n"
			cat $portscan_domains | filter-resolved | cf-check | sort -u | naabu -rate 40000 -silent -verify | httprobe >> $output_folder/naabu.txt
			echo "✅"
		fi
	fi
}


linkDiscovery() {
	alive_domains="$1"
	output_folder="$2"
	if [ "$(cat $alive_domains | wc -l)" -ge "1" ]; then
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█░░░▀█▀░█▀█░█░█░░░█▀▄░▀█▀░█▀▀░█▀▀░█▀█░█░█░█▀▀░█▀▄░█░█
			░█░░░░█░░█░█░█▀▄░░░█░█░░█░░▀▀█░█░░░█░█░▀▄▀░█▀▀░█▀▄░░█░
			░▀▀▀░▀▀▀░▀░▀░▀░▀░░░▀▀░░▀▀▀░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░▀░░▀░
			\033[m"
		else
			echo -e -n "\n\033[1;36m[+] Link Discovery 🔎\033[m"
		fi
		[[ ! -d $output_folder ]] && mkdir $output_folder
		[[ ! -d $output_folder/hakrawler ]] && mkdir $output_folder/hakrawler 2>/dev/null
		[[ ! -d $output_folder/waybackurls ]] && mkdir $output_folder/waybackurls 2>/dev/null
		for d in $(cat $alive_domains); do
			dnohttps="$(echo $d| cut -d "/" -f3-)"
			hakrawler --nocolor -all --url $d >> $output_folder/hakrawler/$dnohttps.txt
			echo $d | waybackurls >> $output_folder/waybackurls/$dnohttps.txt
		done
		cat $output_folder/hakrawler/*.txt | cut -d "]" -f2- | sed -e 's/^[ \t]*//' >> $output_folder/all.txt
		cat $output_folder/waybackurls/*.txt | sed -e 's/^[ \t]*//' >> $output_folder/all.txt
		sort -u $output_folder/all.txt -o $output_folder/all.txt
		if [ "$QUIET" == "True" ]; then
			echo " ✅"
		fi
		all="$(cat $output_folder/all.txt | wc -l)"
		echo -e "\033[35m[+] Found \033[31m$all\033[35m links\033[m"
	fi
}


endpointsEnumeration() {
	alive_domains="$1"
	output_folder="$2"
	if [ "$(cat $alive_domains | wc -l)" -ge "1" ]; then
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█▀▀░█▀█░█▀▄░█▀█░█▀█░▀█▀░█▀█░▀█▀░█▀▀░░░█▀▀░█▀█░█░█░█▄█░█▀▀░█▀▄░█▀█░▀█▀░▀█▀░█▀█░█▀█
			░█▀▀░█░█░█░█░█▀▀░█░█░░█░░█░█░░█░░▀▀█░░░█▀▀░█░█░█░█░█░█░█▀▀░█▀▄░█▀█░░█░░░█░░█░█░█░█
			░▀▀▀░▀░▀░▀▀░░▀░░░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░░░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀
			\033[m"
		else
			echo -e "\n\033[1;36m[+] Endpoints Enumeration 🔎\033[m"
		fi
		if [ "$QUIET" != "True" ]; then
			echo -e "\n\033[36m>>>\033[35m Extracting URLs 🔍\033[m"
			xargs -a $alive_domains -I@ sh -c "python3 $SCRIPTPATH/tools/ParamSpider/paramspider.py -d @ -l high"
		else
			echo -e -n "\n\033[36m>>>\033[35m Extracting URLs 🔍\033[m"
			xargs -a $alive_domains -I@ sh -c "python3 $SCRIPTPATH/tools/ParamSpider/paramspider.py -d @ -l high" > $SCRIPTPATH/paramspidertemp
			rm $SCRIPTPATH/paramspidertemp
			echo " ✅"
		fi
		cat $SCRIPTPATH/output/http:/* >> $output_folder/all.txt
		cat $SCRIPTPATH/output/https:/* >> $output_folder/all.txt
		rm -rf $SCRIPTPATH/output/
		sort -u $output_folder/all.txt -o $output_folder/all.txt
		[[ ! -d $output_folder/js ]] && mkdir $output_folder/js
		echo -e "\n\033[36m>>>\033[35m Enumerating Javascript files 🔍\033[m"
		xargs -P 500 -a $DOMAINS -I@ sh -c 'nc -w1 -z -v @ 443 2>/dev/null && echo @' | xargs -I@ -P10 sh -c 'gospider -a -s "https://@" -d 2 | grep -Eo "(http|https)://[^/\"].*\.js+" | sed "s#\] \- #\n#g" | anew' | grep -Eo "(http|https)://[^/\"].*\.js+" >> $output_folder/js/js.txt
		cat $alive_domains | waybackurls | grep -iE '\.js' | grep -iEv '(\.jsp|\.json)' >> $output_folder/js/js.txt
		sort -u $output_folder/js/js.txt -o $output_folder/js/js.txt
		jslen="$(cat $output_folder/js/js.txt | wc -l)"
		echo -e "\033[32m[+] Found \033[31m$jslen\033[32m JS files\033[m"
		cat $output_folder/js/js.txt | anti-burl | awk '{print $4}' | sort -u >> $output_folder/js/AliveJS.txt
		sort -u $output_folder/js/AliveJS.txt -o $output_folder/js/AliveJS.txt
		jsalivelen="$(cat $output_folder/js/AliveJS.txt | wc -l)"
		echo -e "\033[32m[+] Found \033[31m$jsalivelen\033[32m alive JS files\033[m"
	fi
}


findVuln() {
	alive_domains="$1"
	output_folder="$2"
	if [ "$(cat $alive_domains | wc -l)" -ge "1" ]; then
		if [ "$QUIET" != "True" ]; then
			echo -e "\033[1;32m
			░█░█░█░█░█░░░█▀█░█▀▀░█▀▄░█▀█░█▀▄░▀█▀░█░░░▀█▀░▀█▀░▀█▀░█▀▀░█▀▀
			░▀▄▀░█░█░█░░░█░█░█▀▀░█▀▄░█▀█░█▀▄░░█░░█░░░░█░░░█░░░█░░█▀▀░▀▀█
			░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀░▀░▀▀░░▀▀▀░▀▀▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀▀▀
			\033[m"
		else
			echo -e "\n\033[1;36m[+] Vulnerabilities 🔎\033[m"
		fi
		echo -e "\n\033[36m[+] Finding vulnerabilities with Nuclei 🔍\033[m"
		[[ ! -d $HOME/nuclei-templates ]] && nuclei --update-templates
		[[ ! -d $output_folder ]] && mkdir $output_folder 2>/dev/null
		nuclei -l $alive_domains -t $HOME/nuclei-templates/ -o $output_folder/nuclei.txt --silent
		echo -e "\n\033[36m>>>\033[35m Finding XSS 🤖\033[m"
		list="$OUTFOLDER/link-discovery/all.txt"
		[[ ! -d $output_folder/xss-discovery ]] && mkdir $output_folder/xss-discovery 2>/dev/null
		if [ "$QUIET" != "True" ]; then
			echo -e "\n\033[36m>>>\033[34m Finding XSS with Gxss🤖\033[m"
			cat $OUTFOLDER/link-discovery/all.txt | anti-burl | awk '{print $4}' | Gxss -p XSS | sed '/^$/d' | tee -a $output_folder/xss-discovery/temppossible-xss.txt
		else
			echo -e -n "\n\033[36m>>>\033[34m Finding XSS with Gxss🤖\033[m"
			cat $OUTFOLDER/link-discovery/all.txt | anti-burl | awk '{print $4}' | Gxss -p XSS >> $output_folder/xss-discovery/temppossible-xss.txt
			echo " ✅"
		fi
		sed '/^$/d' $output_folder/xss-discovery/temppossible-xss.txt > $output_folder/xss-discovery/possible-xss.txt
		sort -u $output_folder/xss-discovery/possible-xss.txt -o $output_folder/xss-discovery/possible-xss.txt
		echo -e "\n\033[36m>>>\033[34m Finding XSS with Oneliner🤖\033[m"
		cat $output_folder/xss-discovery/possible-xss.txt | grep "=" | qsreplace '"><script>alert(1)</script>' | while read -r url; do
		req="$(curl --silent --path-as-is --insecure $url | grep -qs '<script>alert(1)')"
		if [ "$req" != "" ]; then
			if [ "$QUIET" != "True" ]; then
				echo "\033[1;31m$req\033[m"
				echo "$req" | tee -a $output_folder/xss-discovery/xss.txt
			else
				echo "$req" >> $output_folder/xss-discovery/xss.txt
			fi
			echo -e "\033[1;32m[+] $url\033[1;31m VULNERABLE\033[m"	
		fi
	done
	rm $output_folder/xss-discovery/temppossible-xss.txt 
	if [ "$FUZZ" == "True" ]; then
		for a in $(cat $output_folder/xss-discovery/possible-xss.txt); do
			echo -e "\033[32m[+] Fuzzing $a\033[m"
			python3 $SCRIPTPATH/tools/XSStrike/xsstrike.py -u $a
		done
		echo -e "\n\033[36m>>>\033[34m Finding XSS with Dalfox🤖\033[m"
		gospider -S $OUTFOLDER/subdomains/alive.txt -c 10 -d 5 --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" --other-source | grep -e "code-200" | awk '{print $5}'| grep "=" | qsreplace -a | dalfox pipe --skip-bav --silence | tee -a $output_folder/xss-discovery/xss.txt
	fi
	xssfound="$(cat $output_folder/xss-discovery/*.txt | wc -l)"
	echo -e "\033[1;33m[!] Found \033[1;31m$xssfound\033[33m possibles XSS\033[m"
	echo -e "\n\033[36m>>>\033[35m Finding 403 HTTP Responses 🤖\033[m"
	for a in $(cat $DOMAINS); do
		r="$(curl -I -s -k $a | grep 'HTTP' | awk '{print $2}')"
		if [ "$r" == "403" ]; then
			echo -e "\033[32m$a \033[35m[$r]\033[m"
			echo $a >> $output_folder/403.txt
			if [ "$FUZZ" == "True" ]; then
				$SCRIPTPATH/scripts/bypass-403.sh $a
			fi
		fi
	done
	if [ -e $output_folder/403.txt ]; then
		xxxfound="$(cat $output_folder/403.txt | wc -l)"
		echo -e "\033[1;33m[!] Found \033[1;31m$xxxfound\033[33m 403 Status Code\033[m"
	else
		echo -e "\033[1;33m[!] Found \033[1;31m0\033[33m 403 Status Code\033[m"
	fi

	echo -e "\n\033[36m>>>\033[35m Finding possible Open Redirect 🤖\033[m"
	grepVuln "$open_redir_parameters" "$list" "$output_folder/possible-open-redir.txt"
	if [ -e $output_folder/open-redir.txt ]; then
		lenopenredir="$(cat $output_folder/open-redir.txt | wc -l)"
		echo -e "\033[1;33m[!] Found \033[1;31m$lenopenredir\033[33m possibles Open Redirects\033[m"
	else
		echo -e "\033[1;33m[!] Found \033[1;31m0\033[33m possibles Open Redirects\033[m"
	fi

	echo -e "\n\033[36m>>>\033[35m Finding possible RCE 🤖\033[m"
	grepVuln "$rce_parameters" "$list" "$output_folder/rce.txt"
	if [ -e $output_folder/rce.txt ]; then
		lenrce="$(cat $output_folder/rce.txt | wc -l)"
		echo -e "\033[1;33m[!] Found \033[1;31m$lenrce\033[33m possibles RCEs\033[m"
	else
		echo -e "\033[1;33m[!] Found \033[1;31m0\033[33m possibles RCEs\033[m"
	fi

	echo -e "\n\033[36m>>>\033[35m Finding possible LFI 🤖\033[m"
	grepVuln "$lfi_parameters" "$list" "$output_folder/lfi.txt"
	cat $list | gf lfi >> $output_folder/lfi.txt
	if [ -e $output_folder/lfi.txt ]; then
		sort -u $output_folder/lfi.txt -o $output_folder/lfi.txt
		lenlfi="$(cat $output_folder/lfi.txt | wc -l)"
		if [ "$FUZZ" == "True" ]; then
			if [ "$(cat $output_folder/lfi.txt | wc -l)" -ge "1" ]; then
				cat $output_folder/lfi.txt | qsreplace FUZZ | while read url; do
				echo -e "\n\033[1;32m>>> Fuzzing $url\033[m"
				ffuf -u $url -mr "root:x" -w $SCRIPTPATH/wordlists/lfi.txt -sf -s -t 100
			done
			fi
		fi
		echo -e "\033[1;33m[!] Found \033[1;31m$lenlfi\033[33m possibles LFIs\033[m"
	else
		echo -e "\033[1;33m[!] Found \033[1;31m0\033[33m possibles LFIs\033[m"
	fi
	echo -e "\n\033[36m>>>\033[35m Finding possible SQLi 🤖\033[m"
	cat $DOMAINS | waybackurls | gf sqli >> $output_folder/possible-sqli.txt
	if [ -e "$output_folder/possible-sqli.txt" ]; then
		sqlifound="$(cat $output_folder/possible-sqli.txt | wc -l)"
		if [ "$sqlifound" -ge "1" ]; then
			echo -e "\033[1;33m[!] Found \033[1;31m$sqlifound\033[33m possibles SQLi\033[m"
		else
			echo -e "\033[1;33m[!] Found \033[1;31m0\033[33m possibles SQLi\033[m"
		fi
	fi
	if [ "$FUZZ" == "True" ]; then
		sqlmap -m $output_folder/possible-sqli.txt --batch --random-agent --level 1 | tee -a $output_folder/sqli.txt
	fi
	fi
}


if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	printBanner
	show_help
	exit
fi

while getopts ":d:w:t:g:s:q:o:f:" ops; do
	case "${ops}" in
		d)
			domain=${OPTARG}
			;;
		w)
			wordlist=${OPTARG}
			;;
		g)
			GHAPIKEY=${OPTARG}
			;;
		s)
			SHODANAPIKEY=${OPTARG}
			;;
		q)
			QUIET="True"
			;;
		o)
			OUTFOLDER=${OPTARG}
			;;
		:)
			if [ "${OPTARG}" == "q" ]; then
				QUIET="True"
			elif [ "${OPTARG}" == "f" ]; then
				FUZZ="True"
			else
				echo -e "\033[1;31m[-] Error: -${OPTARG} requires an argument!\033[m"
				exit
			fi
			;;
		\?)
			echo -e "\033[1;31m[-] Error: -${OPTARG} is an Invalid Option"
			exit
			;;
	esac
done

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
if [ "$OUTFOLDER" == "" ]; then
	OUTFOLDER="$SCRIPTPATH/$domain"
fi
DOMAINS="$OUTFOLDER/subdomains/subdomains.txt"
dep_falt=0

printBanner

echo -e "\033[36m[!] Checking dependencies\033[m"
if [ ! -e $SCRIPTPATH/requirements.txt ]; then
	echo -e "\033[1;31m[-] Could not check dependencies :(\033[m"
	exit
else
	for a in $(cat $SCRIPTPATH/requirements.txt); do
		if ! command -v $a >/dev/null ; then
			echo -e "\033[1;31m[-] $a\033[m"
			dep_falt="1"
		else
			if [ "$QUIET" != "True" ]; then
				echo -e "\033[1;32m[+] $a\033[m"
			fi
		fi
	done
fi

if [ ! -e $SCRIPTPATH/tools ]; then
	echo -e "\033[1;31m[-] The tools folder was not found, run the installer script\033[m"
	dep_falt="1"
else
	if [ ! -e $SCRIPTPATH/tools/CredStuff-Auxiliary ]; then
		dep_falt="1"
	fi
	if [ ! -e $SCRIPTPATH/tools/EyeWitness ]; then
		dep_falt="1"
	fi
	if [ ! -e $SCRIPTPATH/tools/FavFreak ]; then
		dep_falt="1"
	fi
	if [ ! -e $SCRIPTPATH/tools/github-search ]; then
		dep_falt="1"
	fi
	if [ ! -e $SCRIPTPATH/tools/ParamSpider ]; then
		dep_falt="1"
	fi
	if [ ! -e $SCRIPTPATH/tools/XSStrike ]; then
		dep_falt="1"
	fi
	if [ ! -e $SCRIPTPATH/tools/SubDomainizer.py ]; then
		dep_falt="1"
	fi
fi

if [ "$dep_falt" == "0" ]; then
	echo -e "\033[1;32m[+] All right! ✅\033[m"
else
	echo -e "\033[31m[-] There are missing dependencies! ❌\033[m"
	echo -e "Run \033[1;32m./installation.sh\033[m"
	exit
fi

if [ -z "$domain" ]; then
	echo -e "\n\033[31m[-] Unspecified domain! ❌\033[m"
	exit
fi
if [ -z "$wordlist" ]; then
	echo -e "\n\033[32m<<  \033[mYou didn't choose a wordlist. Here are your options: \033[32m >>\033[m"
	for a in $(ls $SCRIPTPATH/wordlists/); do
		pwdWL="$(cd $SCRIPTPATH/wordlists/; pwd)"
		echo -e "\033[1;32m[+] $pwdWL/$a\033[m"
	done
	exit
fi
if [ -z "$GHAPIKEY" ]; then
	GHAPIKEY="False"
fi

if [ -z "$SHODANAPIKEY" ]; then
	SHODANAPIKEY="False"
fi

[[ ! -d $OUTFOLDER ]] && mkdir $OUTFOLDER 2>/dev/null

# +-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+
# |A|S|N| |E|n|u|m|e|r|a|t|i|o|n|
# +-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+
asnEnum $domain $OUTFOLDER/asn

 # +-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+
 # |S|u|b|d|o|m|a|i|n| |E|n|u|m|e|r|a|t|i|o|n|
 # +-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+

 subdomainEnumeration $domain $OUTFOLDER/subdomains

# +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+
# |O|r|g|a|n|i|z|i|n|g| |d|o|m|a|i|n|s|
# +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+
organizeDomains $DOMAINS $OUTFOLDER/subdomains

# +-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
# |S|u|b|d|o|m|a|i|n| |T|a|k|e|o|v|e|r|
# +-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+

subdomainTakeover $DOMAINS $OUTFOLDER/subdomains/subdomain-takeover

# +-+-+-+ +-+-+-+-+-+-+
# |D|N|S| |L|o|o|k|u|p|
# +-+-+-+ +-+-+-+-+-+-+

dnsLookup $DOMAINS $OUTFOLDER

 # +-+-+-+-+-+-+-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+
 # |C|h|e|c|k|i|n|g| |w|h|i|c|h| |d|o|m|a|i|n|s| |a|r|e| |a|c|t|i|v|e|
 # +-+-+-+-+-+-+-+-+ +-+-+-+-+-+ +-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+-+-+

 checkActive $DOMAINS $OUTFOLDER/subdomains

# +-+-+-+ +-+-+-+-+-+-+-+-+-+
# |W|a|f| |D|e|t|e|c|t|i|o|n|
# +-+-+-+ +-+-+-+-+-+-+-+-+-+

wafDetect $OUTFOLDER/subdomains/alive.txt

# +-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+
# |F|a|v|i|c|o|n| |A|n|a|l|y|s|i|s|
# +-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+

favAnalysis $OUTFOLDER/subdomains/alive.txt $OUTFOLDER/favicon-analysis

# +-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+
# |D|i|r|e|c|t|o|r|y| |F|u|z|z|i|n|g|
# +-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+

dirFuzz $OUTFOLDER/subdomains/alive.txt $OUTFOLDER/fuzz

# +-+-+-+-+ +-+-+-+-+-+
# |C|r|e|d| |S|t|u|f|f|
# +-+-+-+-+ +-+-+-+-+-+
credStuff 500 $OUTFOLDER/dorks

# +-+-+-+-+-+-+ +-+-+-+-+-+-+-+
# |G|o|o|g|l|e| |H|a|c|k|i|n|g|
# +-+-+-+-+-+-+ +-+-+-+-+-+-+-+

googleHacking $OUTFOLDER/dorks/google-dorks

# +-+-+-+-+-+-+ +-+-+-+-+-+
# |G|i|t|H|u|b| |D|o|r|k|s|
# +-+-+-+-+-+-+ +-+-+-+-+-+

ghDork $OUTFOLDER/dorks/github-dorks

#  +-+-+-+-+-+-+-+-+-+-+-+
# |S|c|r|e|e|n|s|h|o|t|s|
# +-+-+-+-+-+-+-+-+-+-+-+

screenshots $OUTFOLDER/subdomains/alive.txt $OUTFOLDER/$domain-screenshots

 # +-+-+-+-+ +-+-+-+-+-+-+-+-+
 # |P|o|r|t| |S|c|a|n|n|i|n|g|
 # +-+-+-+-+ +-+-+-+-+-+-+-+-+

 portscan $DOMAINS $OUTFOLDER/DNS/ip_only.txt $OUTFOLDER/portscan/

 # +-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+
 # |E|n|d|p|o|i|n|t|s| |e|n|u|m|e|r|a|t|i|o|n|
 # +-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+

 linkDiscovery $OUTFOLDER/subdomains/alive.txt $OUTFOLDER/link-discovery
 endpointsEnumeration $OUTFOLDER/subdomains/alive.txt $OUTFOLDER/link-discovery

# +-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# |F|i|n|d|i|n|g| |v|u|l|n|e|r|a|b|i|l|i|t|i|e|s|
# +-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
# I'm only using the standard nuclei templates, but you can create and add them in ~/nuclei-templates

findVuln $OUTFOLDER/subdomains/alive.txt $OUTFOLDER/vuln

org="$(echo $domain | cut -d '.' -f1)"
if [ -e $OUTFOLDER/asn/$org.txt ]; then
	asn="$(cat $OUTFOLDER/asn/$org.txt | wc -l)"
else
	asn="0"
fi
subsfound="$(cat $DOMAINS | wc -l)"
subsalive="$(cat $OUTFOLDER/subdomains/alive.txt | wc -l)"
if [ -e $OUTFOLDER/subdomains.txt/takeover.txt ]; then
	takeofound="$(cat $OUTFOLDER/subdomains.txt/takeover.txt | wc -l)"
fi
ips="$(cat $OUTFOLDER/DNS/ip_only.txt | wc -l)"
favfound="$(cat $OUTFOLDER/favicon-analysis/favfreak/*.txt | wc -l)"
fuzzdir="$(ls $OUTFOLDER/fuzz | wc -l)"
fuzzdirfound="$(cat $OUTFOLDER/fuzz/* | wc -l)"
jsfound="$(cat $OUTFOLDER/link-discovery/js/js.txt | wc -l)"
jsalive="$(cat $OUTFOLDER/link-discovery/js/AliveJS.txt | wc -l)"
lfound="$(cat $OUTFOLDER/link-discovery/all.txt | wc -l)"
foundvuln="$(($(cat $OUTFOLDER/vuln/* 2>/dev/null | wc -l)+$(cat $OUTFOLDER/vuln/xss-discovery/* | wc -l)))"
echo -e "\033[1;31m====================================================================================================================\033[m"
echo -e "\033[1;31m====================\033[1;32m Final Results \033[1;31m====================\033[m"
echo -e "\033[1;32m[+] ASNs Found: \033[1;31m$asn\033[m"
echo -e "\033[1;32m[+] Subdomains Found: \033[1;31m$subsfound\033[m"
echo -e "\033[1;32m[+] Subdomains Alive Found: \033[1;31m$subsalive\033[m"
if [ -e $OUTFOLDER/subdomains.txt/takeover.txt ] && [ "$(cat $OUTFOLDER/subdomains.txt/takeover.txt | wc -l)" -ge "1" ]; then
	echo -e "\033[1;32m[+] Subdomains Takeover Found: \033[1;31m$takeofound\033[m"
else
	echo -e "\033[1;32m[+] Subdomains Takeover Found: \033[1;31m0\033[m"
fi
echo -e "\033[1;32m[+] IPs Found: \033[1;31m$ips\033[m"
if [ -e "$OUTFOLDER/DNS/dnsrecon.txt" ]; then
	echo -e "\033[1;32m[+] DNS Enumeration: ✅\033[m"
fi
echo -e "\033[1;32m[+] Favicons Hashes Found: \033[1;31m$favfound\033[m"
echo -e "\033[1;32m[+] Brute Force in directories made in \033[1;31m$fuzzdir\033[1;32m domains with \033[1;31m$fuzzdirfound\033[1;32m directories found\033[m"
echo -e "\033[1;32m[+] More than \033[1;31m$lfound\033[1;32m links were found\033[m"
echo -e "\033[1;32m[+] \033[1;31m$jsfound\033[1;32m JS Files Found, among them \033[1;31m$jsalive\033[1;32m are alive\033[m"
echo -e "\033[1;32m[+] More than \033[1;31m$foundvuln\033[1;32m possible VULNERABILITIES found\033[m"
echo -e "\033[1;32m[+] Check \033[1;31m$OUTFOLDER\033[1;32m and check all dorks manually, Shodan searches, Port Scans and much more!\033[m"
echo -e "\033[1;32mHappy Hunting! 😁\033[m"
echo -e "\033[1;31m====================\033[1;32m DONE \033[1;31m====================\033[m"
echo -e "\033[1;31m====================================================================================================================\033[m"