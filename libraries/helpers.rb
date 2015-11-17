#
# Cookbook Name:: ossec
# Library:: helpers
#
# Copyright 2015, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Chef
  module OSSEC
    module Helpers
      # Gyoku looks for a symbol called :content! but Chef attributes
      # are always stringified. We can't just call symbolize_keys
      # because we need to recurse through the hash structure. Doing
      # this also gives us the opportunity to convert true/false to
      # yes/no, which is handy.
      def self.object_to_ossec(object)
        case object
        when Hash
          object.keys.each do |k|
            if k == 'content!'
              object[:content!] = object_to_ossec(object.delete(k))
            else
              object[k] = object_to_ossec(object[k])
            end
          end
          object
        when Array
          object.map! do |e|
            object_to_ossec(e)
          end
        when TrueClass
          'yes'
        when FalseClass
          'no'
        when NilClass
          ''
        else
          object
        end
      end

      def self.ossec_to_xml(hash)
        require 'gyoku'
        Gyoku.xml object_to_ossec(hash)
      end
    end
  end
end
