# frozen_string_literal: true

actions :create
default_action :create

attribute :id, kind_of: String, name_attribute: true
attribute :github_username, kind_of: String
