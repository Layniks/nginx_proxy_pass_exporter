#!/bin/bash

host=$(hostname)

while true
do

    confs=`ls /etc/nginx/sites-enabled/`

    OIFS=$IFS
    IFS=$'\n'

    for c in $confs; do
	list=`grep -oP "^[^#]+ \K(server [^;]+|server_name [^;]+|proxy_pass [^;]+)" /etc/nginx/sites-enabled/$c`
	t="nginx_upstream_enabled"
	a=0
	opp=""
	z=""
	server="no"

	if [[ $list != ""  ]]; then
	    echo "Processing: $c"

	    for i in $list; do
		echo "Parsing: $i"
		key=`echo $i | awk -F ' ' '{print $1}'`
		val=`echo $i | awk -F ' ' '{print $2}' | tr -d '"'`

		if [[ $key == "server" ]]; then
    		    server="$val"
    		    a=1
		fi
		if [[ $key == "server_name" && $b != true ]]; then
    		    server_name="$val"
		fi
		if [[ $key == "proxy_pass" ]]; then
    		    if [[ $val != $opp ]]; then
        		proxy_pass="$val"
		    fi
    		    opp=$val

		    if [[ "${t}{host=\"$host\", upstream_server=\"$server\", server_name=\"$server_name\", proxy_pass=\"$proxy_pass\"} $a" != $z ]]; then
			serverO=`echo "$server"` # | jq -sRr '@uri'`
			server_nameO=`echo "$server_name"` # | jq -sRr '@uri'`
			proxy_passO=`echo "$proxy_pass" | sed -E 's|^https?://||; s|/||'` # | jq -sRr '@uri'`
			protocol=`echo "$proxy_pass" | sed -E 's|^(https?)://.*|\1|'`

			echo "${t}{host=\"$host\", upstream_server=\"$serverO\", server_name=\"$server_nameO\", proxy_pass=\"$proxy_passO\", protocol=\"$protocol\", conf_file=\"$c\"} $a"
			echo "Sending metrics to PushGateway"
			echo "$t $a" | curl -sX PUT --data-binary @- "http://10.1.1.78:9091/metrics/job/nginx_exporter/instance/$host/upstream_server/$serverO/server_name/$server_nameO/proxy_pass/$proxy_passO/protocol/$protocol/conf_file/$c"
			if [[ $? != "" ]]; then 
			    echo "Done"
			else
		    	    echo "Error"
			fi
		    fi
		    z="${t}{host=\"$host\", upstream_server=\"$server\", server_name=\"$server_name\", proxy_pass=\"$proxy_pass\"} $a"
		fi
	    done
	fi
    done

    IFS=$OIFS

    sleep 14400

done