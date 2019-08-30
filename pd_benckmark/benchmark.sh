get_time(){
		hours=`expr $1 \* 3600`
		sce=`expr $2 \* 60`
		t=`expr $hours + $sce`
		da=`date +%Y%m%d`
		tda=`date -d "$da" +%s`
		echo `expr $t + $tda` 
}

echo "begin test"
work1="./workload/workload_1"
work2="./workload/workload_2"
# load data

for i in 1 2 3 4 5
do 
		$1 load mysql -P $work1 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable"$i -p threadcount=128 >> bench.log &	
done
wait

work_pid=0

while true
do
	if [[ $[work_pid] != 0 ]]
	then
		$1 run mysql -P $work1 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable" -p threadcount=128 >> bench.log &	
		pid1=$!
		sleep 120
		kill -9 $work_pid
		work_pid=$pid1
	else 
		$1 run mysql -P $work1 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable" -p threadcount=128 >> bench.log &
		work_pid=$i
	fi	

	now=`date +%s` 
	begin1=$(get_time 7 0)
	end1=$(get_time 10 30)

	while [[ $[now] -gt $[begin1] ]] && [[ $[now] -lt $[end1] ]]
	do
		for i in 1 2 3 4 5
		do
			$1 run mysql -P $work2 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable"$i -p threadcount=128 >> bench.log &
			sleep 300
		done 
		now=`date +%s`
	done

	begin2=$(get_time 10 30)
	end2=$(get_time 14 0)

	while [[ $[now] -gt $[begin2] ]] && [[ $[now] -lt $[end2] ]]
	do
		for i in 1 2 3 4 5
		do	
			$1 run mysql -P $work2 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable"$i -p threadcount=258 >> bench.log &
			sleep 150
		done
		
		now=`date +%s`
	done

	if [[ $[work_pid] != 0 ]]
	then
		$1 run mysql -P $work1 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable" -p threadcount=128 >> bench.log & 
		pid1=$!
		sleep 150
		kill -9 $work_pid
		work_pid=$pid1
	fi   

	now=`date +%s`
	begin3=$(get_time 14 0)
	end3=$(get_time 17 30)

	while [[ $[now] -gt $[begin3] ]] && [[ $[now] -lt $[end3] ]]
	do
		for i in 1 2 3 4 5
		do
			$1 run mysql -P $work2 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable"$i -p threadcount=258 >> bench.log &				
			sleep 300
		done
		now=`date +%s`
	done

	begin4=$(get_time 17 30)
	end4=$(get_time 21 30)

	while [[ $[now] -gt $[begin4] ]] && [[ $[now] -lt $[end4] ]]
	do                                      
		for i in 1 2 3 4 5                                              
		do                                                                          
			$1 run mysql -P $work2 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable"$i -p threadcount=258 >> bench.log &
			sleep 100
		done                                                                                                    
		now=`date +%s`				
	done
	
	if [[ $[work_pid] != 0 ]]
	then
		$1 run mysql -P $work1 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable" -p threadcount=128 >> bench.log &
		pid1=$!
		sleep 150
		kill -9 work_pid
		work_pid=$pid1
	fi													    fi

	begin5=$(get_time 21 30)
	end5=$(get_time 24 0)
	now=`date +%s`
	while [[ $[now] -gt $[begin5] ]] && [[ $[now] -lt $[end5] ]]
	do
		for i in 1 2 3 4 5
		do
			$1 run mysql -P $work2 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable"$i -p threadcount=258 >> bench.log &
			sleep 450
		done
		now=`date +%s`
	done

	begin6=$(get_time 0 0)
	end6=$(get_time 7 0)
	now=`date +%s`
	while [[ $[now] -gt $[begin5] ]] && [[ $[now] -lt $[end5] ]]
	do
		for i in 1 2 3 4 5
		do
			$1 run mysql -P $work2 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable"$i -p threadcount=258 >> bench.log &
			sleep 1000
		done
		now=`date +%s`
	done
done
echo "test end"
