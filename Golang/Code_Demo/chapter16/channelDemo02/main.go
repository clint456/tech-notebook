package main

import (
	"fmt"
)

type Cat struct {
	Name string
	Age  int
}

func main() {
	var allChan chan interface{}
	allChan = make(chan interface{}, 10)

	cat1 := Cat{Name: "tim", Age: 18}
	cat2 := Cat{Name: "Tom", Age: 180}

	allChan <- cat1
	allChan <- cat2
	allChan <- 10
	allChan <- "jack"

	catll := <-allChan
	cat := catll.(Cat)
	fmt.Println(cat.Name)

}
