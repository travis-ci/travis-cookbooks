#!/bin/sh

logger [travis-ci] "Checking that eth0 is up..."

# used to recover eth0 when/if VM NICs fail. MK.
sudo ifup eth0

logger [travis-ci] "Done checking eth0. True story, bro"
