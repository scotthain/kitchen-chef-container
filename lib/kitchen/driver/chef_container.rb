# -*- encoding: utf-8 -*-
#
# Author:: Scott Hain (<shain@getchef.com>)
#
# Copyright (C) 2014, Scott Hain
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'kitchen'
require 'kitchen/driver/docker'
require 'net/ssh'
require 'kitchen/monkey_patches/ssh'

module Kitchen

  module Driver

    # chef-container Docker driver for Kitchen.
    #
    # @author Scott Hain <shain@getchef.com>
    class ChefContainer < Kitchen::Driver::Docker
      default_config :init_command, "/opt/chef/embedded/bin/runsvdir -P /opt/chef/service"

      def converge(state)
        path = "/opt/chef/bin:/opt/chef/embedded/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin"

        # this command requires no PTY, so that it can continue to run runit after the shell dies.
        Kitchen::NoPTYSSH.new(*build_ssh_args(state)) do |conn|
          run_remote("sudo -E PATH=#{path}:$PATH nohup #{config[:init_command]} < /dev/null > /dev/null 2>&1 &", conn)
        end

        super
      end

    end
  end
end