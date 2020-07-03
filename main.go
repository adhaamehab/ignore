package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"
)

func main() {

	args := os.Args[1:]
	if len(args) <= 0 {
		panic("you must select a target language")
	}
	fileName := fmt.Sprintf("%s.gitignore", strings.Title(strings.ToLower(args[0])))
	downloadURL := fmt.Sprintf("https://raw.githubusercontent.com/github/gitignore/master/%s", fileName)
	if err := DownloadFile(downloadURL, fileName); err != nil {
		log.Fatal(err)
	}
	// Download file from github repo
	fmt.Println("file downloaded at: ", fileName)
}

// DownloadFile downloads the file from github gignore rep
func DownloadFile(url string, filepath string) error {
	out, err := os.Create(filepath)
	if err != nil {
		return err
	}
	defer out.Close()

	// Get the data
	resp, err := http.Get(url)
	if err != nil || resp.StatusCode != 200 {
		return err
	}
	defer resp.Body.Close()
	// Write the body to file
	_, err = io.Copy(out, resp.Body)
	if err != nil {
		return err
	}

	return nil
}
