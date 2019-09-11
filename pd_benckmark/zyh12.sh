work1_pid=0
work2_pid=0
now=`date +%s`
if [[ $now -gt $1 && $now -lt $2 ]]
then
	work="./workload/workload_2"
	$3 run mysql -P $work -p mysql.host=$4 -p mysql.port=$5 -p table="usertable1" -p threadcount=$6 >> ./bench.log &	
	work1_pid=$!
	$3 run mysql -P $work -p mysql.host=$4 -p mysql.port=$5 -p table="usertable2" -p threadcount=$6 >> ./bench.log &
	work2_pid=$!
else 
	echo "return"
	return
fi  

while [[ $now -gt $1 && $now -lt $2 ]]
do
	sleep 60
	now=`date +%s`
done
kill -9 $work1_pid
kill -9 $work2_pid
