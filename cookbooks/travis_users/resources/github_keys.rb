# frozen_string_literal: true

unified_mode true

actions :create
default_action :create

attribute :id, kind_of: String, name_attribute: true
attribute :github_username, kind_of: String
