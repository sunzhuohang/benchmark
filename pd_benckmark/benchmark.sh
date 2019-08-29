get_time(){
	hours=`expr $1 \* 3600`
	sce=`expr $2 \* 60`
	echo `expr $hours + $sce`
}

# run go-ycsb
# $1 is begin time    $2 is end time
# $3 is ./bin/go-ycsb $4 is the tidb addr $5 is the tidb port
# $6 is the tablename $7 is the workload $8 is if only run one 
# $9 is if need sleep 

rungoycsb(){

	da=`date +%Y%m%d`
	tda=`date -d "$da" +%s`
	
	begin=`expr $1 + $tda`
	end=`expr $2 + $tda`
	now=`date +%s`

	while [[ $[now] -gt $[begin] ]] && [[ $[now] -lt $[end] ]]
	do
		echo "begin run"
		$3 run mysql -p mysql.host=$4 -p mysql.port=$5 -p table=$6 -p threadcount=128 -P $7 >> bench.log
		echo "run end"
		if [[ $8 = 1 ]]
		then 
			if [[ $9 != 0 ]]
			then
				sleep $9
			fi
			break 
		fi
		now=`date +%s`
	done
}


echo "begin test"
work1="./workload/workload_1"
work2="./workload/workload_2"
work3="./workload/workload_3"
work4="./workload/workload_4"
work5="./workload/workload_5"
# load data

for i in 1 2 3 4 5
do 
	$1 load mysql -P $work1 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable"$i -p threadcount=128 >> bench.log &	
done
wait

while true
do
#	for i in 1 2 3 4 5
#	do  
#		begin=$(get_time 7 00)
#		end=$(get_time 10 0)
#		rungoycsb $begin $end $1 $2 $3 "usertable"$i $work1 0 0 &
#	done 
##	wait
#
#	for i in 1 2 3 4 5
#	do 
#		begin=$(get_time 10 0)
#		end=$(get_time 11 30)	
#		rungoycsb $begin $end $1 $2 $3 "usertable"$i $work3 1 0
#	done
#	
#	for i in 1 2 3 4 5
#	do 
#		begin=$(get_time 11 30)
#		end=$(get_time 14 0)	
#		rungoycsb $begin $end $1 $2 $3 "usertable"$i $work2 0 0 &
#	done
#
#	for i in 1 2 3 4 5
#	do 
##		begin=$(get_time 14 0)
#		end=$(get_time 17 30)	
#		rungoycsb $begin $end $1 $2 $3 "usertable"$i $work3 1 0
#	done
#
	for i in 1 2 3 4 5
	do 
		begin=$(get_time 17 30)
		end=$(get_time 20 00)	
		rungoycsb $begin $end $1 $2 $3 "usertable"$i $work4 0 0 &
	done
#
	for i in 1 2 3 4 5
	do 
		begin=$(get_time 20 0)
		end=$(get_time 24 0)	
		rungoycsb $begin $end $1 $2 $3 "usertable"$i $work5 0 0 
	done
#
#	for i in 1 2 3 4 5
#	do 
#		begin=$(get_time 0 0)
#		end=$(get_time 7 0)	
#		rungoycsb $begin $end $1 $2 $3 "usertable"$i $work5 1 60
#	done
done
echo "test end"
