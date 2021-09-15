# frozen_string_literal: true

Chef::DSL::Recipe.include TravisJava::OracleJdk

install_oraclejdk 9
