custom Cookbook
===============
We'll add any custom recipes here for the Drupaldelphia kitchen when it is inconvinient to use an available recipe.

Requirements
------------
none

Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### custom::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['dev']['user']</tt></td>
    <th>String</th>
    <td>Owner of drupal sites folder</td>
    <td><tt>vagrant</tt></td>
  </tr>
  <tr>
    <td><tt>['drupaldelphia']['source']['repo']</tt></td>
    <th>String</th>
    <td>Location of the drupaldelphia repository</td>
    <td><tt>git@github.com:dkinzer/drupaldelphia.git</tt></td>
  </tr>
  <tr>
    <td><tt>['drupaldelphia']['source']['ref']</tt></td>
    <th>String</th>
    <td>References the branch of the repository</td>
    <td><tt>master</tt></td>
  </tr>
</table>

Usage
-----
#### custom::default
Just include `custom` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[custom]"
  ]
}
```
