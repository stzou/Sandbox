package main

import (
    "log"
    "github.com/DataDog/datadog-go/v5/statsd"
)

func main() {
    statsd, err := statsd.New("unix:///var/run/datadog/dsd.socket")
    if err != nil {
        log.Fatal(err)
    }
}
