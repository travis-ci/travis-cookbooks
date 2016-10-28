#!/usr/bin/env bash
set -o errexit

main() {
  set -o xtrace
  iptables -I INPUT 1 -p icmp -j ACCEPT
  iptables -I INPUT 2 -p udp --dport 33434:33523 -j REJECT
  iptables -I INPUT 3 -i lo -j ACCEPT
  iptables -I INPUT 4 -m state --state ESTABLISHED,RELATED -j ACCEPT
  iptables -I INPUT 5 -p tcp --dport ssh -j ACCEPT
  iptables -A INPUT -j DROP
}

main "$@"
