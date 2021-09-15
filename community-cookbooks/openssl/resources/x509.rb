
actions [:create]
default_action :create

attribute :owner,       kind_of: String
attribute :group,       kind_of: String
attribute :expire,      kind_of: Integer
attribute :mode,        kind_of: [Integer, String]
attribute :org,         kind_of: String, required: true
attribute :org_unit,    kind_of: String, required: true
attribute :country,     kind_of: String, required: true
attribute :common_name, kind_of: String, required: true
attribute :key_file,    kind_of: String, default: nil
attribute :key_pass,    kind_of: String, default: nil
attribute :key_length,  equal_to: [1024, 2048, 4096, 8192], default: 2048
