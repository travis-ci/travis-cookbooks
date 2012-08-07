default[:golang] = {
  # can be "stable" or "tip"
  :version => "stable",
  :multi => {
    :versions => %w(go1),
    :default_version  => "go1"
  }
}
