package main

import (
	"context"
	"fmt"
	"log"

	"github.com/hetznercloud/hcloud-go/v2/hcloud"
)

func main() {
	client := hcloud.NewClient(hcloud.WithToken("wfiWWNF306mc9EgwQdFKMLivbz9CBoU5hG26bXe6X0T5CkMopYwSbPrTcAxGfzaA"))

	server, _, err := client.Server.GetByID(context.Background(), 1)
	if err != nil {
		log.Fatalf("error retrieving server: %s\n", err)
	}
	if server != nil {
		fmt.Printf("server 1 is called %q\n", server.Name)
	} else {
		fmt.Println("server 1 not found")
	}
}
