default[:tmate_proxy][:src_path] = "/srv/tmate-proxy-src"
default[:tmate_proxy][:app_path] = "/srv/tmate-proxy"

c = default[:tmate_proxy][:config]

c[:logger][:console][:format] = "$time $metadata[$level] $message\n"
c[:logger][:console][:metadata] = [:session_id]

c[:ex_statsd][:host] = "localhost"

c[:rollbax][:access_token] = "XXX"
c[:rollbax][:enabled] = false

c[:tmate][:master][:nodes] = []
c[:tmate][:master][:session_url_fmt] = "disabled"

c[:tmate][:websocket][:enabled] = false

c[:tmate][:webhook][:enabled] = true
c[:tmate][:webhook][:allow_user_defined_urls] = false
c[:tmate][:webhook][:urls] = []

c[:tmate][:daemon][:hmac_key] = "key"
