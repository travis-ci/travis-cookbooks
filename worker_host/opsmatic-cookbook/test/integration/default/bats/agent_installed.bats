@test "opsmatic_public debian repo is added" {
	if [ ! -e /etc/lsb-release ]; then
		skip "Not on a debian system"
	fi
	result="$(cat /etc/apt/sources.list.d/opsmatic_public.list | grep any | wc -l)"
	[ "$result" -eq "1" ]
}

@test "opsmatic_public yum repo is added" {
	if [ -e /etc/lsb-release ]; then
		skip "Not on a centos-like system"
	fi
	result="$(cat /etc/yum.repos.d/opsmatic_public.repo  | grep opsmatic_packagecloud | wc -l)"
	[ "$result" -eq "1" ]
}

@test "opsmatic-agent exists" {
	run stat /usr/bin/opsmatic-agent
	[ "$status" -eq 0 ]
}

@test "opsmatic-agent's credentials are installed" {
	run stat /var/db/opsmatic-agent/identity/host_id /var/db/opsmatic-agent/identity/client-key.key /var/db/opsmatic-agent/identity/client-cert.pem
	[ "$status" -eq 0 ]
}

@test "opsmatic-agent is running" {
	result="$(initctl list | grep opsmatic-agent | grep running | wc -l)"
	[ "$result" -eq "1" ]
}
