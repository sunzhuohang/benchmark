package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"time"
	"strconv"
)

func timetick(ch chan int) {
	tick := time.Tick(time.Minute)
	for {
		select {
		case <- tick:
			ch <- 1
		}
	}
}

func main(){
	fmt.Println("begin")

	ch := make(chan int)

	go timetick(ch)

	for  {
		res := <- ch
		if res == 1 {
			go get_region()
		}
	}
}

func get_region() {
	t := time.Now().Unix()
	name := strconv.FormatInt(t,10)
	resp,err := http.Get("http://10.233.30.243:2379/pd/api/v1/regions")
	defer resp.Body.Close()
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}

	content, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println(err.Error())
		return
	}

	filename := "./Region/"+ name +".log"
	f, err := os.OpenFile(filename, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	defer f.Close()
	if err != nil {
		fmt.Println(err.Error())
		return
	}
	f.Write(content)
}
