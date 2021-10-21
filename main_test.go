package main

import (
	"os"
	"testing"

	"github.com/ad/template-golang/app"
)

func TestMain(m *testing.M) {
	// call flag.Parse() here

	os.Exit(m.Run())
}

func TestDummy(t *testing.T) {
	if 2+2 != 4 {
		t.Fatal("fatal error")
	}
}

func TestAppRun(t *testing.T) {
	if app.Run() != nil {
		t.Fatal("app run error")
	}
}

func Test_main(t *testing.T) {
	tests := []struct {
		name string
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			main()
		})
	}
}
