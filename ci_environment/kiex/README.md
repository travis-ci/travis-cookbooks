kiex Cookbook
=============
This cookbook installs and configures kiex, as well as installs elixir

Requirements
------------
Requires 'kerl' for managing Erlang runtimes


Usage
-----
#### kiex::default

Include `kiex` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[kiex]"
  ]
}
```
