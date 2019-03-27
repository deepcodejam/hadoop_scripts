
dedup_classpath()
{
	files=$(echo $CLASSPATH | tr ":" "\n")
	lf=","
	#lf=$'\n'
	jar_files=""
	jar_file_names=""
	filenames=""
	for file in $files; do
		if [ `is_jar $file` ]; then
			jar_files+="$file$lf"
			jar_file_names+="$(echo $file|sed 's/.*\///')$lf"
			#filenames+="$(echo $file|sed 's/.*\///')$lf"
		else
			load_jars $file
		fi
		#echo $file
	done
	dup_line_nos=''
	i=1
	names_cnt=`echo "$jar_file_names" | wc -l`
	CLASSPATH=`python ~/mac_user_dir/Documents/code/python/dedup_classpath.py $jar_files $jar_file_names`
	#echo "classpath: $CLASSPATH"
	#echo 'classpath is set'
	echo $CLASSPATH
	return
	echo "already returned"
	#for (( i=0; i<$names_cnt; ++i ))
	for name in $jar_file_names
	do
		for (( j=i+1; j<$names_cnt; ++j))
		do
			rname=`echo $jar_file_names | sed -n "${j}p"`
			echo "rname: $rname"
			if [ "$name" = "$rname" ]; then
				dup_line_nos+="$j "
			fi
		done
		((i++))
	done

	echo "Dup Line Nos: $dup_line_nos"
	#for name in $jar_file_names; do
	#	echo "name: $name"
	#done
	#for name in $jar_files; do
	#	echo "jarname: $name"
	#done
}

is_jar()
{
	file=$1
	if [ ${file:((${#file}-4))} = ".jar" ]; then
		echo 1
	fi
	echo ""
}

load_jars()
{
	dir=$1
	#echo "diris: $dir"
	for i in "$dir"/*.jar; do
		#echo "jar: $i"
		if [[ $i != *\** ]]; then
			jar_files+="$i$lf"
			jar_file_names+="$(echo $i|sed 's/.*\///')$lf"
		fi
	done
	#echo "loading jars"
}



#IN="bla@some.com;john@home.com"
#mails=$(echo $IN | tr ";" "\n")
#for addr in $mails; do
#    echo $addr
#done
#'''
#for dup in $(sort -k1,1 -u file.txt | cut -d' ' -f1); do grep -n -- "$dup" file.txt; done
