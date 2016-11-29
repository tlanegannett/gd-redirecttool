# test-redirecttoolserver Cookbook
=======================

TODO: Enter the cookbook description here.

Requirements
------------
#### cookbooks
- `example`
_add your list of cookbook dependencies here_

#### Attributes

Key | Type | Description | Default
--- | ---- | ----------- | -------
['test-redirecttoolserver']['example']['name'] | String | name of some example | 'value'

#### Supported Platforms

- Centos 6.x
- Centos 7.1

Usage
-----
#### test-redirecttoolserver::default

Just include `test-redirecttoolserver` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[test-redirecttoolserver]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a Jira Ticket for tracking your work and the reason for the change
3. Create a named feature branch with the Jira ticket included (like `PAAS-1337-add_component_x`)
4. Write your change
5. Write tests for your change (if applicable)
6. Run the tests, ensuring they all pass
7. Bump the version in `metadata.rb` and update `CHANGELOG.md` with the new version and what you changed.
8. Commit your changes with your Jira ticket in the commit message (like "git commit -m 'PAAS-1337 added component x and spruced up docs on y"` )
9. Submit a Pull Request using Github

License and Authors
-------------------
Authors: paas-delivery@gannett.com
_Copyright (c) 2016 Gannett Co., Inc, All Rights Reserved._
