#!/usr/bin/env bash
set -o errexit

main() {
  set -o xtrace
  sudo iptables -I INPUT 1 -p icmp -j ACCEPT
  sudo iptables -I INPUT 2 -p udp --dport 33434:33523 -j REJECT
  sudo iptables -I INPUT 3 -i lo -j ACCEPT
  sudo iptables -I INPUT 4 -m state --state ESTABLISHED,RELATED -j ACCEPT
  sudo iptables -I INPUT 5 -p tcp --dport ssh -j ACCEPT
  sudo iptables -A INPUT -j DROP
}

main "$@"
