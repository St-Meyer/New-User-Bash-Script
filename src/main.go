package main

import (
	"fmt"
	"sort"
	"strings"
	"time"
)

func mathe(x, y int) (int, int, int, int) {
	return x + y, x - y, x * y, x / y
}

func zählung(x int) {
	for i := 0; i < x; i++ {
		fmt.Println(i + 1)
	}
}

func bytes() {
	sum := 1
	for sum < 1000 {
		sum += sum
	}
	fmt.Println(sum)
}

func vergleich(x, y int) {
	if x < y {
		fmt.Println(x)
	} else {
		fmt.Println(y)
	}
}

func schalter(x int) {
	switch x {
	case 1:
		fmt.Println("Hallo")
	case 2:
		fmt.Println("Welt")
	case 3:
		fmt.Println(":)")
	}
}

func Wochentage() string {
	wochentag := time.Now().Weekday()
	uebersetzung := map[time.Weekday]string{
		time.Monday:    "Montag",
		time.Tuesday:   "Dienstag",
		time.Wednesday: "Mittwoch",
		time.Thursday:  "Donnerstag",
		time.Friday:    "Freitag",
		time.Saturday:  "Samstag",
		time.Sunday:    "Sonntag",
	}
	return uebersetzung[wochentag]
}

func tage(x string) {
	tages := Wochentage()
	if x == tages {
		fmt.Println("heute")
	} else {
		fmt.Println("heute nicht")
	}
}

func prime(x int) bool {
	prime := true
	k := 2
	for k*k <= x && prime == true {
		if x%k == 0 {
			prime = false
		}
		k = k + 1
	}
	return prime
}

func Contamination(text, char string) string {
	var output strings.Builder
	for i := 0; i < len(text); i++ {
		output.WriteString(char)
	}
	return output.String()
}

func CountSheeps(numbers []bool) int {
	count := 0
	for i := 0; i < len(numbers); i++ {
		if numbers[i] == true {
			count++
		}
	}
	return count
}

func CalculateYears(years int) (result [3]int) {
	result[0] = years
	result[1] = 15
	result[2] = 15
	if years == 2 {
		result[1] = 24
		result[2] = 24
	}
	if years > 2 {
		result[1] = 24 + (years-2)*4
		result[2] = 24 + (years-2)*5
	}
	return result
}

func GetSize(w, h, d int) (result [2]int) {
	result[0] = 2*(w*h) + 2*(w*d) + 2*(d*h)
	result[1] = w * d * h
	return result
}

func IsPalindrome(str string) bool {
	var newstring string
	for _, v := range str {
		newstring = string(v) + newstring
	}
	newstring = strings.ToLower(newstring)
	str = strings.ToLower(str)
	return str == newstring
}

func UnluckyDays(year int) int {
	var result int
	for month := 1; month <= 12; month++ {
		date := time.Date(year, time.Month(month), 13, 0, 0, 0, 0, time.UTC)
		if date.Weekday() == time.Friday {
			result++
		}
	}
	return result
}

func SortByLength(arr []string) (newarr []string) {
	sort.Slice(arr, func(i, j int) bool {
		return len(arr[i]) < len(arr[j])
	})
	return arr
}

func Add(n int) func(int) int {
	return func(m int) int {
		return n + m
	}
}

func Capitalize(st string, arr []int) string {
	newstring := strings.Split(st, "")
	for _, i := range arr {
		if i >= 0 && i < len(newstring) {
			newstring[i] = strings.ToUpper(newstring[i])
		}
	}
	return strings.Join(newstring, "")
}

func Disemvowel(comment string) string {
	var result []string
	for _, v := range comment {
		if strings.ContainsAny(strings.ToLower(string(v)), "aeiou") {
			continue
		}
		result = append(result, string(v))
	}
	return strings.Join(result, "")
}

func IsTriangle(a, b, c int) bool {
	return a+b > c && b+c > a && a+c > b
}

func Fib(n int) int {

	if n == 0 {
		return 0
	}
	if n == 1 {
		return 1
	}
	ret := 0
	f1 := 0
	f2 := 1
	for i := 2; i <= n; i++ {
		ret = f1 + f2
		f1 = f2
		f2 = ret
	}
	return ret
}

func Gimme(array [3]int) int {
	if (array[0] > array[1] && array[0] < array[2]) || (array[0] < array[1] && array[0] > array[2]) {
		return 0
	}
	if (array[1] > array[0] && array[1] < array[2]) || (array[1] > array[2] && array[1] < array[0]) {
		return 1
	}
	return 2
}

func main() {
	//fmt.Println(mathe(2, 3))
	//zählung(10)
	//bytes()
	//var input string
	//fmt.Scanln(&input)
	//fmt.Println(input)
	//vergleich(1, 2)
	//schalter(2)
	//fmt.Println(runtime.GOOS)
	//var tag string
	//fmt.Scanln(&tag)
	//tage(tag)
	//var intput int
	//fmt.Scanln(&intput)
	//fmt.Println(prime(intput))
	//fmt.Println(Contamination("abcdef", "k"))
	//fmt.Println(IsPalindrome("Abba"))
	//fmt.Println(UnluckyDays(2025))
	//fmt.Println(Capitalize("hello", []int{1, 3}))
	//fmt.Println(Disemvowel("Hallo"))
	//fmt.Println(IsTriangle(1, 2, 3))
	//fmt.Println(Fib(8))
	fmt.Println(Gimme([3]int{2, 3, 1}))
}
