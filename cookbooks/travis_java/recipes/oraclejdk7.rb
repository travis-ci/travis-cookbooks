# frozen_string_literal: true

Chef::Recipe.send(:include, TravisJava::OracleJdk)

install_oraclejdk 7
