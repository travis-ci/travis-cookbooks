# frozen_string_literal: true

Chef::Recipe.send(:include, TravisJava::IBMJava)

install_ibmjava 8
