# frozen_string_literal: true

# Cloud Foundry Java Buildpack
# Copyright 2013-2020 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'fileutils'
require 'java_buildpack/jre'
require 'java_buildpack/jre/open_jdk_like'

module JavaBuildpack
  module Jre

    # Encapsulates the detect, compile, and release functionality for selecting an Azul Platform Prime JRE.
    class ZingJRE < OpenJDKLike
      # (see JavaBuildpack::Component::ModularComponent#command)
      def command
      end

      # (see JavaBuildpack::Component::ModularComponent#sub_components)
      def sub_components(context)
        [
          OpenJDKLikeJre.new(sub_configuration_context(context, 'jre')
                             .merge(component_name: self.class.to_s.space_case)),
          OpenJDKLikeSecurityProviders.new(context)
        ]
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
        @droplet.java_opts.add_preformatted_options '-XX:+ExitOnOutOfMemoryError'
        super
      end
    end
  end
end
