FROM registry.fedoraproject.org/fedora:35

USER 0

RUN dnf install --assumeyes ruby ruby-devel rubygem-bundler redhat-rpm-config gcc

COPY --chown=1000:1000 ./ /opt/app/

# This file relies on RbConfig being already loaded, let's make that require explicit.
RUN sed -i -e '/require_relative "\.\.\/tree_spell_checker"/ a\require "rbconfig"' /usr/share/ruby/did_you_mean/spell_checkers/require_path_checker.rb

USER 1000

WORKDIR /opt/app

RUN bundle install --standalone

RUN bundle binstub --standalone cucumber

USER 0

# Remove rubygems to simulate a system without rubygems
RUN dnf remove --assumeyes rubygems

USER 1000

# Make sure the libraries are loaded and call the cucumber binstub.
RUN RUBYOPT="-r./bundle/bundler/setup" bin/cucumber
