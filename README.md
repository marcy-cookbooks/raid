RAID Cookbook
=============
This cookbook configure RAID and mount the RAID device.

Requirements
------------
* Chef 11 or higher

Attributes
----------
#### raid::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['raid']['verbose']</tt></td>
    <td>String</td>
    <td>Create raid device</td>
    <td><tt>/dev/md0</tt></td>
  </tr>
  <tr>
    <td><tt>['raid']['level']</tt></td>
    <td>String</td>
    <td>RAID Level</td>
    <td><tt>stripe</tt></td>
  </tr>
  <tr>
    <td><tt>['raid']['devices']</tt></td>
    <td>Array</td>
    <td>RAID devices</td>
    <td><tt>["/dev/xvdb", "/dev/xvdc"]</tt></td>
  </tr>
  <tr>
    <td><tt>['raid']['fs']</tt></td>
    <td>String</td>
    <td>File system</td>
    <td><tt>ext4</tt></td>
  </tr>
  <tr>
    <td><tt>['raid']['mount_point']</tt></td>
    <td>String</td>
    <td>Mount Point</td>
    <td><tt>/mnt/md0</tt></td>
  </tr>
</table>

Usage
-----
#### raid::default

Just include `raid` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[raid]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
License: MIT
Authors: Marcy
