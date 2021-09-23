<p align="center">
  <img width="300" height="100" src="https://user-images.githubusercontent.com/72598486/134552117-1ce19e3a-c8f8-4799-8854-40e647c1a7f9.png">
</p>


## DNS-FENDER

A Proof-of-Concept tool utilizing open DNS resolvers to produce an amplification attack against web servers. Using Shodan APIs and native Linux commands, this tool is in development to cripple web servers using spoofed DNS recursive queries. Recently, a 15 year old produced a 300 GB DoS attack against a well-known website using 50 lines of code. Though Cloudflare never revealed the source code, I thought I would take a stab at recreating the basic idea behind the attack. Any feedback, ways to strengthen the tool, and improvements are greatly appreciated. Feel free to develop and reuse this code! Let's make it even better!
 
## Background

DNS Amplification Attacks are a way for an attacker to magnify the amount of bandwidth they can target at a potential victim. Imagine you are an attacker and you control a botnet capable of sending out 100Mbps of traffic. While that may be sufficient to knock some sites offline, it is a relatively trivial amount of traffic in the world of DDoS. In order to increase your attack's volume, you could try and add more compromised machines to your botnet. That is becoming increasingly difficult. Alternatively, you could find a way to amplify your 100Mbps into something much bigger.

The original amplification attack was known as a SMURF attack. A SMURF attack involves an attacker sending ICMP requests (i.e., ping requests) to the network's broadcast address (i.e., X.X.X.255) of a router configured to relay ICMP to all devices behind the router. The attacker spoofs the source of the ICMP request to be the IP address of the intended victim. Since ICMP does not include a handshake, the destination has no way of verifying if the source IP is legitimate. The router receives the request and passes it on to all the devices that sit behind it. All those devices then respond back to the ping. The attacker is able to amplify the attack by a multiple of how ever many devices are behind the router.

## DNS Amplification

There are two criteria for a good amplification attack vector: 1) query can be set with a spoofed source address (e.g., via a protocol like ICMP or UDP that does not require a handshake); and 2) the response to the query is significantly larger than the query itself. DNS is a core, ubiquitous Internet platform that meets these criteria and therefore has become the largest source of amplification attacks.

DNS queries are typically transmitted over UDP, meaning that, like ICMP queries used in a SMURF attack, they are fire and forget. As a result, their source attribute can be spoofed and the receiver has no way of determining its veracity before responding.

![Dos](https://user-images.githubusercontent.com/72598486/134555284-7cb380e9-1937-48fc-8827-e6d3a21221af.png)

## Identifying Open Resolvers

Using the ```dig``` command, we can identify if the DNS server is an open resolver:

```
$ dig TARGET @ x.x.x.x 
```

A DNS Open-resolver configured to resolve recursive queries will return a response similar to the example below, followed by a set of DNS records:

```
; <<>> DiG 9.10.31-P4-Ubuntu <<>> TARGET @ x.x.x.x
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 53931
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
```

**Note** ‘status’ NOERROR

A DNS server not allowing recursive queries will instead respond with an error message similar to this:

```
; <<>> DiG 9.10.31-P4-Ubuntu <<>> TARGET @x.x.x.x
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: REFUSED, id: 47106
;; flags: qr rd; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 0
;; WARNING: recursion requested but not available
```

**Note** ‘status’ REFUSED

# DNS-FENDER Script

Using Shodan APIs, *DNS-FENDER* identifies open resolvers across the internet, saves IP addresses to a CSV file, and runs the ```dig``` command against your target using open DNS resolvers. This tool is still in development and any improvements, ideas, or ways to make the code stronger is strongly appreciated!

# Installation

To install the Shodan library, simply:

```
$ pip install shodan
```

Or if you don't have pip installed (which you should seriously install):

```
$ easy_install shodan
```
Or if you're running an older version of the Shodan Python library and want to upgrade:

```
easy_install -U shodan
```

You can get your API key from your Shodan account page located at:

```
https://account.shodan.io/
```

Then just:

```
$ chmod +x DNS-Fender.sh
$ ./DNS-Fender.sh
```

Enter your API Key and Target to attack!
