default[:haskell][:multi] = {
  :ghcs => {
    "7.6.3" => {
      :platform_version => "2013.2.0.0",
      :default => true
    },
    "7.4.2" => {
      :platform_version => "2012.2.0.0",
      :default => false
    },
    "7.0.4" => {
      :platform_version => "2011.4.0.0",
      :default => false
    }
  }
}
