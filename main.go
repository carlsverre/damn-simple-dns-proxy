package main

import (
	"fmt"
	"github.com/miekg/dns"
	"math/rand"
	"time"
)

func checkErr(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	conf, err := dns.ClientConfigFromFile("/etc/resolv.conf")
	checkErr(err)

	client := new(dns.Client)

	proxyRequest := func(w dns.ResponseWriter, r *dns.Msg) {
		targetServer := fmt.Sprintf("%s:%s", conf.Servers[rand.Intn(len(conf.Servers))], conf.Port)
		response, _, err := client.Exchange(r, targetServer)
		if err == nil {
			w.WriteMsg(response)
		} else {
			m := new(dns.Msg)
			m.SetRcode(r, dns.RcodeRefused)
			w.WriteMsg(m)
		}
	}

	dns.HandleFunc(".", proxyRequest)

	server := &dns.Server{Addr: ":53", Net: "udp"}
	go server.ListenAndServe()
	for {
		time.Sleep(5 * time.Second)
	}
}
