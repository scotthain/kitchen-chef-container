# -*- encoding: utf-8 -*-
#
# Author:: Scott Hain (<shain@getchef.com>)
#
# Copyright (C) 2014, Chef Software Inc
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

module Kitchen

  class NoPTYSSH < Kitchen::SSH
    def exec_with_exit(cmd)
      exit_code = nil
      session.open_channel do |channel|

        # the only change between this and the original version is this one doesn't require PTY

        channel.exec(cmd) do |ch, success|

          channel.on_data do |ch, data|
            logger << data
          end

          channel.on_extended_data do |ch, type, data|
            logger << data
          end

          channel.on_request("exit-status") do |ch, data|
            exit_code = data.read_long
          end
        end
      end
      session.loop
      exit_code
    end

  end
end
