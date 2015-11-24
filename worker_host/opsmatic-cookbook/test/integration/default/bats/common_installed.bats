@test "/etc/default/opsmatic-global is added and has the correct token in it" {
	result="$(cat /etc/default/opsmatic-global | grep "OPSMATIC_INTEGRATION_TOKEN" | grep "4f15f0b3-6881-41e0-a8a7-c1d9e85c8018" | wc -l)"
	[ "$result" -eq "1" ]
}

