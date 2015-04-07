google-chrome Cookbook
======================
This cookbook installs the latest stable Google Chrome.

Requirements
------------
None.

Usage
-----
#### google-chrome::default

Just include `google-chrome` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[google-chrome]"
  ]
}
```
