SLURM Cookbook
=======================
TODO: Enter the cookbook description here.

e.g.
This cookbook makes your favorite breakfast sandwich.

Requirements
------------

#### packages
- `yum-epel` - slurm needs munge from EPEL on RHEL like systems.

Attributes
----------

#### slurm::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['slurm']['cluster_name']</tt></td>
    <td>String</td>
    <td>Cluster your node is associated with</td>
    <td><tt>localhost</tt></td>
  </tr>
  <tr>
    <td><tt>['slurm']['slurm']['partition']</tt></td>
    <td>Array of hashes</td>
    <td>Partitions for your slurm cluster</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['slurm']['slurm']['config']</tt></td>
    <td>Array of key value pairs</td>
    <td>Config options dropped into slurm.conf</td>
    <td><tt>[]</tt></td>
  </tr>
  <tr>
    <td><tt>['slurm']['slurmdbd']['config']</tt></td>
    <td>Array of key value pairs</td>
    <td>Config options dropped into slurmdbd.conf</td>
    <td><tt>[]</tt></td>
  </tr>
</table>

Usage
-----
#### slurm::default

Just include `slurm` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[slurm]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
