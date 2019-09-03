get_time(){
	hours=`expr $1 \* 3600`
	sce=`expr $2 \* 60`
	t=`expr $hours + $sce`
	da=`date +%Y%m%d`
	tda=`date -d "$da" +%s`
	echo `expr $t + $tda` 
}

rungoycsb(){
	now=`date +%s`
	work="./workload/workload_2"
	while [[ $now -gt $1 && $now -lt $2 ]]
	do
		for i in 1 2 3 4 5
		do
			$3 run mysql -P $work -p mysql.host=$4 -p mysql.port=$5 -p table="usertable"$i -p threadcount=128 >> bench.log &
			sleep $6
		done 
		now=`date +%s`
	done
}

gobase(){
	work_pid=0
	while true
	do
		if [[ $pid != 0 ]]
		then 
			$1 run mysql -P $2 -p mysql.host=$3 -p mysql.port=$4 -p table="usertable"$i -p threadcount=128 >> bench.log &
			pid=$!
			sleep 300
			kill -9 $work_pid
			work_pid=pid
		else 
			$1 run mysql -P $2 -p mysql.host=$3 -p mysql.port=$4 -p table="usertable"$i -p threadcount=128 >> bench.log &
			work_pid=$!
		fi
		sleep $5
	done
}	

echo "begin test"
work1="./workload/workload_1"

for i in 1 2 3 4 5
do 
		$1 load mysql -P $work1 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable"$i -p threadcount=128 >> bench.log &	
done
wait

work_pid=0

while true
do
	fg=0
	if [[ $fg = 0 ]]
	then 
		gobase $1 $work1 $2 $3 8000 &
		fg=1
	fi

	now=`date +%s`
	begin1=$(get_time 7 0)
	end1=$(get_time 10 30)

	rungoycsb $begin1 $end1 $1 $2 $3 250

	begin2=$(get_time 10 30)
	end2=$(get_time 14 0)

	rungoycsb $begin2 $end2 $1 $2 $3 150
	
	begin3=$(get_time 14 0)
	end3=$(get_time 17 30)

	rungoycsb $begin3 $end3 $1 $2 $3 300
	
	begin4=$(get_time 17 30)
	end4=$(get_time 21 30)

	rungoycsb $begin4 $end4 $1 $2 $3 200
	

	begin5=$(get_time 21 30)
	end5=$(get_time 24 0)

	rungoycsb $begin5 $end5 $1 $2 $3 300
	

	begin6=$(get_time 0 0)
	end6=$(get_time 7 0)

	rungoycsb $begin6 $end6 $1 $2 $3 600
	
done
echo "test end"
