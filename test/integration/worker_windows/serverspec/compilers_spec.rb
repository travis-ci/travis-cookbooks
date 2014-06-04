require_relative 'spec_helper'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "Compilers" do
  skip "Microsoft Visual Studio Express"
  skip "Go"
end