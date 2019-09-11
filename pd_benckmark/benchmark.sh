#！bin/bash
get_time(){
        hours=`expr $1 \* 3600`
        sce=`expr $2 \* 60`
        t=`expr $hours + $sce`
        da=`date +%Y%m%d`
        tda=`date -d "$da" +%s`
        echo `expr $t + $tda`
}

gobase(){
        while true
        do
                $1 run mysql -P ./workload/workload_1 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable" -p threadcount=12 >> bench.log
        done
}

echo "begin test"

gobase $1 $2 $3 &

while true
do

 
        begin=$(get_time 5 10)
        end=$(get_time 5 25)
		./zyh12.sh $begin $end $1 $2 $3 16
 
        begin1=$(get_time 5 25)
        end1=$(get_time 5 40)
		./zyh123.sh $begin1 $end1 $1 $2 $3 16

        begin2=$(get_time 5 40)
        end2=$(get_time 6 0)
		./zyh12345.sh $begin2 $end2 $1 $2 $3 16

        begin3=$(get_time 6 0)
        end3=$(get_time 6 10)
		./zyh123.sh $begin3 $end1 $3 $2 $3 16 

        begin4=$(get_time 6 10)
        end4=$(get_time 6 30)
		./zyh12.sh $begin1 $end1 $1 $2 $3 16

done
echo "test end"
