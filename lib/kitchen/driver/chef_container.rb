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

module Kitchen

  module Driver

    # chef-container Docker driver for Kitchen.
    #
    # @author Scott Hain <shain@getchef.com>
    class ChefContainer < Kitchen::Driver::Docker
      default_config :init_command, "/opt/chef/embedded/bin/runsvdir-start -P /opt/chef/service"

      # def create(state)
      #   super
      #   path = "/opt/chef/bin:/opt/chef/embedded/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin"
      #   command = "sh -c 'PATH=#{path} #{config[:init_command]}'"

      #   old_run = config[:run_command]
      #   config[:run_command] = command
      #   run_command = build_run_command(state[:image_id])
      #   puts "OMMANNDD" + run_command
      #   output = docker_command(run_command)
      #   puts "RETURN: " + output
      #   config[:run_command] = old_run

      # end

      def converge(state)
        path = "/opt/chef/bin:/opt/chef/embedded/bin:/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin"
#        command = "sudo nohup env PATH=#{path} #{config[:init_command]} & > /tmp/blargs"

        # don't make this a single command - in order to make the command actually run,
        # you actually have to dump it to a script. silly ruby.
        stupid_script_string = <<-STUPID.gsub(/^ {10}/, '')
          #!/bin/sh -xe
          export PATH=#{path}:$PATH
          nohup sudo -E #{config[:init_command]} < /dev/null > /dev/null 2>&1 &
        STUPID

          # my_command = "sudo -E /bin/sh -c 'nohup sudo -E #{config[:init_command]}< /dev/null > /dev/null 2>&1 &'"
        Kitchen::SSH.new(*build_ssh_args(state)) do |conn|
          run_remote("sudo echo '#{stupid_script_string}' > /tmp/hacky_runit_start.sh", conn)
          run_remote("chmod 755 /tmp/hacky_runit_start.sh", conn)
          run_remote("sudo -E /tmp/hacky_runit_start.sh", conn)
        end

        super
      end

    end
  end
end