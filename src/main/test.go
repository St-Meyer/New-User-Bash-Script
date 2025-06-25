package main

import (
	"fmt"
	"time"
)

func Wochentag() string {
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

func main() {
	fmt.Println("Heute ist:", Wochentag())
}
