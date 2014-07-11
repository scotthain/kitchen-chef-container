# Kitchen::Chef-Container

A Test Kitchen Driver for Using Chef-Container on Docker.

## Requirements

* [Kitchen-Docker][(https://github.com/portertech/kitchen-docker)]
* [Chef-Container][(http://docs.opscode.com/containers.html)]

## Installation and Setup

Please read the Test Kitchen [docs][test_kitchen_docs] for more details.

Example `.kitchen.local.yml`:

```
---
driver:
  name: chef_container

provisioner:
  name: chef_zero
  client_rb:
    require: 'chef-init'

platforms:
  - name: ubuntu-12.04
    run_list:
      - recipe[apt::default]
    driver_config:
      require_chef_omnibus: false
      image: chef/ubuntu_12.04
      socket: tcp://192.168.59.100:2375
```

## Default Configuration

This driver can currently supports only the Docker Chef/Ubuntu 12.04 image.

## Configuration

See [Kitchen-Docker][(https://github.com/portertech/kitchen-docker)] for base configuration options

## Contributing
Please read [CONTRIBUTING.md](CONTRIBUTING.md)

## License
Full License: [here](LICENSE)

kitchen-chef-container - a driver for chef-container

Author:: Scott Hain (<shain@getchef.com>)  
Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.  
License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.