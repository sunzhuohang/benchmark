#！bin/bash
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
	while [[ $now -gt $1 && $now -lt $2 ]]
	do
		echo $1 $now $2 $6 $7 >> zyh.log
		$3 run mysql -P ./workload/workload_2 -p mysql.host=$4 -p mysql.port=$5 -p threadcount=$6 >> bench.log &
		sleep $7
		now=`date +%s`
	done
}

gobase(){
	while true
	do
		$1 run mysql -P ./workload/workload_1 -p mysql.host=$2 -p mysql.port=$3 -p threadcount=12 >> bench.log
	done
}

echo "begin test"

gobase $1 $2 $3 &

echo "begin while"
while true
do

echo " No1 0:00-8:00"
# 4
	begin=$(get_time 15 0)
	end=$(get_time 17 0)
	rungoycsb $begin $end $1 $2 $3 4 700
# 8
	begin=$(get_time 17 0)
	end=$(get_time 18 0)
	rungoycsb $begin $end $1 $2 $3 8 400
# 16
	begin=$(get_time 18 0)
	end=$(get_time 19 0)
	rungoycsb $begin $end $1 $2 $3 16 250
# 32
	begin=$(get_time 19 0)
	end=$(get_time 21 0)
	rungoycsb $begin $end $1 $2 $3 32 180
# 16
	begin=$(get_time 21 0)
	end=$(get_time 22 0)
	rungoycsb $begin $end $1 $2 $3 16 250
# 8
	begin=$(get_time 22 0)
	end=$(get_time 23 0)
	rungoycsb $begin $end $1 $2 $3 8 400
#4
	begin=$(get_time 23 0)
	end=$(get_time 23 59)
	rungoycsb $begin $end $1 $2 $3 4 700

echo " No2 8:00-16:00"
# 4
	begin=$(get_time 0 0)
	end=$(get_time 1 0)
	rungoycsb $begin $end $1 $2 $3 4 700
# 8
	begin=$(get_time 1 0)
	end=$(get_time 2 0)
	rungoycsb $begin $end $1 $2 $3 8 400
# 16
	begin=$(get_time 2 0)
	end=$(get_time 3 0)
	rungoycsb $begin $end $1 $2 $3 16 250
# 32
	begin=$(get_time 3 0)
	end=$(get_time 5 0)
	rungoycsb $begin $end $1 $2 $3 32 180
# 16
	begin=$(get_time 5 0)
	end=$(get_time 6 0)
	rungoycsb $begin $end $1 $2 $3 16 250
# 8
	begin=$(get_time 6 0)
	end=$(get_time 7 0)
	rungoycsb $begin $end $1 $2 $3 8 400
# 4
	begin=$(get_time 7 0)
	end=$(get_time 9 0)
	rungoycsb $begin $end $1 $2 $3 4 700

echo " No3 16:00-24:00"

# 8
	begin=$(get_time 9 0)
	end=$(get_time 10 0)
	rungoycsb $begin $end $1 $2 $3 8 400

# 16
	begin=$(get_time 10 0)
	end=$(get_time 11 0)
	rungoycsb $begin $end $1 $2 $3 16 250
# 32
	begin=$(get_time 11 0)
	end=$(get_time 13 0)
	rungoycsb $begin $end $1 $2 $3 32 180
# 16
	begin=$(get_time 13 0)
	end=$(get_time 14 0)
	rungoycsb $begin $end $1 $2 $3 16 250
# 8
	begin=$(get_time 14 0)
	end=$(get_time 15 0)
	rungoycsb $begin $end $1 $2 $3 8 4000

	echo " one over"
done
echo "test end"
