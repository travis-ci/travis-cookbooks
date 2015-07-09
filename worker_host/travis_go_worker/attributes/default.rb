default[:travis][:worker][:settings] = {
    "PROVIDER" => "bluebox",
}

set[:papertrail][:watch_files]["/var/log/upstart/travis-worker.log"] = 'travis-worker'
