default[:golang] = {
  # can be "stable" or "tip"
  :version => "stable",
  :multi => {
    :versions => %w(go1.0.3 go1.1.2 go1.2.2 go1.3),
    :default_version  => "go1.3",
    :aliases => {
      "go1"   => "go1.0.3",
      "go1.0" => "go1.0.3",
      "go1.1" => "go1.1.2",
      "go1.2" => "go1.2.2"
    }
  }
}
