default[:golang] = {
  # can be "stable" or "tip"
  :version => "stable",
  :multi => {
    :versions => %w(go1.0.3),
    :default_version  => "go1.0.3",
    :aliases => {
      "go1" => "go1.0.3"
    }
  }
}
