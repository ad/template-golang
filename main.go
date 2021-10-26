package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/ad/template-golang/app"
)

var (
	Version        = "development"
	CommitHash     = "n/a"
	BuildTimestamp = "n/a"
)

func main() {
	fmt.Printf("started, version %s(%s) build at %s\n", Version, CommitHash, BuildTimestamp)

	gracefulShutdown := make(chan os.Signal, 1)
	signal.Notify(gracefulShutdown, syscall.SIGINT, syscall.SIGTERM)

	err := app.Run()
	if err != nil {
		fmt.Println("app run error:", err)

		os.Exit(1)
	}

	<-gracefulShutdown

	_, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer handleTermination(cancel)

}

func handleTermination(cancel context.CancelFunc) {
	fmt.Println("Done!")

	cancel()
}
