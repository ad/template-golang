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
	version = "development"
)

func main() {
	fmt.Println("started, version", version)

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
