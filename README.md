# aruba-without-rubygems
The purpose is to showcase the error when aruba is ran on a system without
the rubygems library present.

Without Rubygems present, trying to run cucumber test suite with aruba loaded
results in this exception:
```
undefined method `win_platform?' for Gem:Module (NoMethodError)
/opt/app/bundle/ruby/3.0.0/gems/aruba-2.0.0/lib/aruba/platforms/windows_platform.rb:21:in `match?'
/opt/app/bundle/ruby/3.0.0/gems/aruba-2.0.0/lib/aruba/platform.rb:8:in `each'
/opt/app/bundle/ruby/3.0.0/gems/aruba-2.0.0/lib/aruba/platform.rb:8:in `find'
/opt/app/bundle/ruby/3.0.0/gems/aruba-2.0.0/lib/aruba/platform.rb:8:in `<module:Aruba>'
/opt/app/bundle/ruby/3.0.0/gems/aruba-2.0.0/lib/aruba/platform.rb:5:in `<top (required)>'
/opt/app/bundle/ruby/3.0.0/gems/aruba-2.0.0/lib/aruba/api.rb:6:in `require'
/opt/app/bundle/ruby/3.0.0/gems/aruba-2.0.0/lib/aruba/api.rb:6:in `<top (required)>'
/opt/app/bundle/ruby/3.0.0/gems/aruba-2.0.0/lib/aruba/cucumber.rb:3:in `require'
/opt/app/bundle/ruby/3.0.0/gems/aruba-2.0.0/lib/aruba/cucumber.rb:3:in `<top (required)>'
/opt/app/features/support/env.rb:1:in `require'
/opt/app/features/support/env.rb:1:in `<top (required)>'
/opt/app/bundle/ruby/3.0.0/gems/cucumber-7.1.0/lib/cucumber/glue/registry_and_more.rb:122:in `require'
/opt/app/bundle/ruby/3.0.0/gems/cucumber-7.1.0/lib/cucumber/glue/registry_and_more.rb:122:in `load_code_file'
/opt/app/bundle/ruby/3.0.0/gems/cucumber-7.1.0/lib/cucumber/runtime/support_code.rb:142:in `load_file'
/opt/app/bundle/ruby/3.0.0/gems/cucumber-7.1.0/lib/cucumber/runtime/support_code.rb:81:in `block in load_files!'
/opt/app/bundle/ruby/3.0.0/gems/cucumber-7.1.0/lib/cucumber/runtime/support_code.rb:80:in `each'
/opt/app/bundle/ruby/3.0.0/gems/cucumber-7.1.0/lib/cucumber/runtime/support_code.rb:80:in `load_files!'
/opt/app/bundle/ruby/3.0.0/gems/cucumber-7.1.0/lib/cucumber/runtime.rb:278:in `load_step_definitions'
/opt/app/bundle/ruby/3.0.0/gems/cucumber-7.1.0/lib/cucumber/runtime.rb:74:in `run!'
/opt/app/bundle/ruby/3.0.0/gems/cucumber-7.1.0/lib/cucumber/cli/main.rb:29:in `execute!'
bundle/ruby/3.0.0/gems/cucumber-7.1.0/bin/cucumber:9:in `<main>'
```

## Reproducing

### Using container build

The `Dockerfile` contains all steps necessary to create an environment without
Rubygems installed when runnning `aruba`.

With podman run:
```console
$ podman build ./
```

Similarly with docker run:
```console
$ docker build ./
```

### Manually
These steps will be specific for Fedora, but the algorithm can be applied
to other systems as well. These steps presume that you are in the same
directory as this README.

1. Install Ruby, the Bundler gem and all libraries necessary to build binary extensions.
```console
$ sudo dnf install --assumeyes ruby ruby-devel rubygem-bundler redhat-rpm-config gcc
```
2. Add `require "rbconfig"` to `did_you_mean` gem (the require is missing there)
3. Install the bundle dependencies, specify the `--standalone` as we want this
to work without rubygems.
```console
$ bundle install --standalone
```
4. Generate binstub for cucumber, specify the `--standalone` option here as well
```console
$ bundler binstub --standalone cucumber
```
5. Remove Rubygems from the system to prevent the ability to load it.
```console
$ sudo dnf install --assumeyes rubygems
```
6. Run the test suite, with the bundler generated `setup.rb` preloaded,
which sets up load paths without rubygems.
```console
$ RUBYOPT=-r./bundle/bundler/setup bin/cucumber
```
