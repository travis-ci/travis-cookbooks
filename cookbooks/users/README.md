users Cookbook
=====================

Creates users for Travis CI servers.

Requirements
------------

#### Platforms

Currently this only supports Ubuntu.

Attributes
----------

#### users::default

`['users']` is an array of elements with the following keys, one element for each user:

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>id</tt></td>
    <td>String</td>
    <td>the username of the user</td>
    <td>(this is required)</td>
  </tr>
  <tr>
    <td><tt>ssh_keys</tt></td>
    <td>Array of Strings</td>
    <td>the list of SSH keys to install to the user's ~/.ssh/authorized_keys</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>github_username</tt></td>
    <td>String</td>
    <td>the GitHub username of the user, used to fetch ssh keys if <tt>ssh_keys</tt> is empty</td>
    <td><tt>""</tt></td>
  </tr>
  <tr>
    <td><tt>shell</tt></td>
    <td>String</td>
    <td>Path to the shell to use</td>
    <td><tt>"/bin/zsh"</tt></td>
  </tr>
  <tr>
    <td><tt>password</tt></td>
    <td>String</td>
    <td>The hashed version of the password to use for this user</td>
    <td>no password</td>
  </tr>
</table>

Usage
-----
#### user::default

Specify some users in the `users` attribute and add `users` to the node's `run_list`:

```json
{
  "name":"my_node",
  "users": [
    { "id": "exampleuser" }
  ],
  "run_list": [
    "recipe[users]"
  ]
}
```

