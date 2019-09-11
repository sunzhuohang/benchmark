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
        work="./workload/workload_2"
        while [[ $now -gt $1 && $now -lt $2 ]]
        do
                for i in 1 2 3 4 5
                do
                        $3 run mysql -P $work -p mysql.host=$4 -p mysql.port=$5 -p table="usertable"$i -p threadcount=$6 >> bench.log &
                        now=`date +%s`
                        if [[ $now -gt $2 ]]
                        then
                                return
                        fi
                        sleep $7
                done
                now=`date +%s`
        done
}

gobase(){
        work_pid=0
        i=1
        while (( $i <=30 ))
        do
                $1 run mysql -P $2 -p mysql.host=$3 -p mysql.port=$4 -p table="usertable"$i -p threadcount=12 >> bench.log
                let "int++"
        done
}

echo "begin test"
work1="./workload/workload_1"

#for i in 1 2 3 4 5
#do
#               $1 load mysql -P $work1 -p mysql.host=$2 -p mysql.port=$3 -p table="usertable"$i -p threadcount=128 >> bench.log &
#done
#wait

work_pid=0

fg=0
while true
do
        if [[ $fg = 0 ]]
        then
                gobase $1 $work1 $2 $3 &
                fg=1
        fi
# 0-6
        begin=$(get_time 16 0)
        end=$(get_time 22 0)
        rungoycsb $begin $end $1 $2 $3 4 700

# 6-8
        begin1=$(get_time 22 0)
        end1=$(get_time 24 0)
        rungoycsb $begin1 $end1 $1 $2 $3 8 500

# 8-11:30
        begin2=$(get_time 0 0)
        end2=$(get_time 3 30)
        rungoycsb $begin2 $end2 $1 $2 $3 16 350

# 11:30-15:30
        begin3=$(get_time 3 30)
        end3=$(get_time 7 30)
        rungoycsb $begin3 $end3 $1 $2 $3 32 250

#15:30-18:30
        begin4=$(get_time 7 30)
        end4=$(get_time 10 30)
        rungoycsb $begin4 $end4 $1 $2 $3 16 350

#18:30-21:30

        begin5=$(get_time 10 30)
        end5=$(get_time 13 30)
        rungoycsb $begin5 $end5 $1 $2 $3 8 500

#21:30-24:00
        begin6=$(get_time 13 30)
        end6=$(get_time 16 0)
        rungoycsb $begin6 $end6 $1 $2 $3 4 700

done
echo "test end"
