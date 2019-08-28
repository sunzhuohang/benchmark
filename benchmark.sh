get_time(){
	hours=`expr $1 \* 3600`
	sce=`expr $2 \* 60`
	echo `expr $hours + $sce`
}

rungoycsb(){

	da=`date +%Y%m%d`
	tda=`date -d "$da" +%s`
	
	begin=`expr $1 + $tda`
	end=`expr $2 + $tda`
	now=`date +%s`

	while [[ $[now] -gt $[begin] ]] && [[ $[now] -lt $[end] ]]
	do
		echo "begin load"	
		$3 load tikv -p tikv.pd=$4 -p table=$5 -P $6
		echo "begin run"
		$3 run tikv -p tikv.pd=$4 -p table=$5 -P $6
		echo "run end"
		if [[ $7 = 1 ]]
		then 
			if [[ $8 !=0 ]]
			then
				sleep $8
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

while true
do
	for i in 1 2 3 4 5
	do  
		begin=$(get_time 7 00)
		end=$(get_time 10 0)
		rungoycsb $begin $end $1 $2 "usertable"$i $work1 0 0 &
	done 
	wait

	for i in 1 2 3 4 5
	do 
		begin=$(get_time 10 0)
		end=$(get_time 11 30)	
		rungoycsb $begin $end $1 $2 "usertable"$i $work3 1 0
	done
	
	for i in 1 2 3 4 5
	do 
		begin=$(get_time 11 30)
		end=$(get_time 14 0)	
		rungoycsb $begin $end $1 $2 "usertable"$i $work2 0 0 &
	done

	for i in 1 2 3 4 5
	do 
		begin=$(get_time 14 0)
		end=$(get_time 17 30)	
		rungoycsb $begin $end $1 $2 "usertable"$i $work3 1 0
	done

	for i in 1 2 3 4 5
	do 
		begin=$(get_time 17 30)
		end=$(get_time 23 0)	
		rungoycsb $begin $end $1 $2 "usertable"$i $work4 0 0 &
	done

	for i in 1 2 3 4 5
	do 
		begin=$(get_time 23 0)
		end=$(get_time 24 0)	
		rungoycsb $begin $end $1 $2 "usertable"$i $work5 1 60 
	done

	for i in 1 2 3 4 5
	do 
		begin=$(get_time 0 0)
		end=$(get_time 7 0)	
		rungoycsb $begin $end $1 $2 "usertable"$i $work5 1 60
	done
done
echo "test end"
