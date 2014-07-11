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

require 'kitchen/provisioner/chef_zero'

module Kitchen

  module Provisioner

    # Chef Client Test Harness provisioner.
    #   to use this - add something like this under provisioner section of your .kitchen.yml
    #   provisioner:
    #     name: chef_test_harness
    #     chef_git_hash: 6b463773ffc91056146a59c7e69f14e563821604
    #     chef_git_url: "github.com/opscode/chef"
    #
    # @author Scott Hain
    class ChefContainer < ChefZero
      default_config :init_command, "/opt/chef/embedded/bin/runsvdir -P /opt/chef/service"


      def prepare_command
        path = "/opt/chef/bin:/opt/chef/embedded/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin"
        
        if local_mode_supported?
          # start up runsvdir

            # nohup #{sudo("env PATH=#{path} #{config[:init_command]} >&- 2>&- <&- &")}

          prepare_string = <<-PREPARE.gsub(/^ {10}/, '')
            nohup #{sudo("env PATH=#{path} #{config[:init_command]} < /dev/null > /dev/null 2>&1 &")}
            echo "I RANNNNNN"
          PREPARE
          prepare_string
        else
          ruby_bin = config[:ruby_bindir]
          
          # use Bourne (/bin/sh) as Bash does not exist on all Unix flavors
          #
          # * we are installing latest chef in order to get chef-zero and
          #   Chef::ChefFS only. The version of Chef that gets run will be
          #   the installed omnibus package. Yep, this is funky :)
          prepare_string = <<-PREPARE.gsub(/^ {10}/, '')
            sh -c '
            #{chef_client_zero_env(:export)}
            if ! #{sudo("#{ruby_bin}/gem")} list chef-zero -i >/dev/null; then
              echo ">>>>>> Attempting to use chef-zero with old version of Chef"
              echo "-----> Installing chef zero dependencies"
              #{sudo("#{ruby_bin}/gem")} install chef --no-ri --no-rdoc --conservative
            fi
            nohup #{sudo("env PATH=#{path} #{config[:init_command]} < /dev/null > /dev/null 2>&1 &")}
          PREPARE
          puts "PREP: " + prepare_string
          return prepare_string
        end
      end

      private
    end
  end
end
