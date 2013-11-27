# Stairs

It's a pain to set up new developers on your codebase. Stairs makes it easy.

### The Problem

Apps these days come with dependencies—S3, Facebook, Twitter, Zencoder, etc. We
can stub certain things in development, but we also want to make sure we're
developing in a realistic setting. Satisfying all of these requirements can
really slow down onboarding time when adding new developers to your existing
codebase.

### The Solution

Every codebase should come with a script to set itself up. An interactive
README, if you will. __Stairs__ aims to provide the tools to make writing these
scripts fast and easy. Scripts try to automate as much as possible and provide
interactive prompts for everything else.

[![Build Status](https://travis-ci.org/patbenatar/stairs.png?branch=master)](https://travis-ci.org/patbenatar/stairs)
[![Code Climate](https://codeclimate.com/github/patbenatar/stairs.png)](https://codeclimate.com/github/patbenatar/stairs)

## Setup

### Rails

Add Stairs to your `Gemfile`:

```ruby
gem "stairs"
```

[Define your script](#defining-scripts) in `setup.rb` at the root of your
project.

### Not Rails

Same as above, but you'll have to manually add the Stairs Rake tasks to your
`Rakefile`.

```ruby
require "stairs/tasks"
```

## Usage

### Basic

In an app with a `setup.rb`, just run the rake task:

```
$ rake newb
```

### Advanced

If you want more control, use the `stairs` command line utility:

```
$ stairs --help
Usage: stairs [options]
        --use-defaults               Use defaults when available
```

## Defining scripts

A script composes many steps that setup a project.

```ruby
setup :secret_token

setup :s3
setup :zencoder, required: false

setup :misc do
  env "CHECK_IT", provide("Cool check it value")
end

rake "db:setup"

finish "Just run rails s and sidekiq to get rolling!"
```

[See Example CLI](#example-cli)

### Collecting values
```ruby
value = provide "Something"
value = provide "Another", required: false
provide "More", default: "a-default"
```

### Asking questions
```ruby
i_should = choice "Should I?"
choice "Should I?" do |yes|
  do_something if yes
end
dinner = choice "Meat or vegetables?", ["Meat", "Vegetables"]
```

### Setting env vars
Stairs currently supports writing environment variables for rbenv-vars, RVM, and dotenv.

```ruby
env "NAME", value
```

### Writing files
```ruby
write "awesome: true", "config/settings.yml"
write_line "more: false", "config/settings.yml"
```

### Misc helpers

Run rake tasks
```ruby
rake "task_name"
```

Display a message when setup completes
```ruby
finish "Now that you're done, go have a drink!"
```

### Defining setup steps

```ruby
setup :a_cool_service do
  # ...
end
```

#### Using predefined steps (aka plugins)
```ruby
setup :s3
setup :facebook, required: false
```

## Plugins for common setups

### Built-in

* `:secret_token` sets a secure random secret token
* `:postgresql` quickly setup database.yml for use with PostgreSQL
* `:facebook` interactive prompt for setting Facebook app credentials

### Available as independent gems

Any plugin that has specific dependencies on third party gems is shipped
independently to avoid maintaining those dependencies within Stairs.

* `:s3` interactive prompt for setting AWS + S3 bucket access credentials:
  [patbenatar/stairs-steps-s3][s3]
* `:balanced` automatically creates a test Marketplace on Balanced:
  [patbenatar/stairs-steps-balanced][balanced]

### Defining custom plugins

Steps inherit from `Stairs::Step` and live in `Stairs::Steps`, have a title,
description, and implement the `run` method. See those included and in the
various extension gems for examples.

## Example CLI

Given the [example script above](#defining-scripts), the CLI would look like
this:

```
$ rake newb
Looks like you're using rbenv to manage environment variables. Is this correct? (Y/N): Y
= Running script setup.rb
== Running S3
AWS access key: 39u39d9u291
AWS secret: 19jd920i10is0i01i0s01ks0kfknkje
Do you have an existing bucket? (Y/N): Y
Bucket name (leave blank for app-dev): my-cool-bucket
== Completed S3
== Starting Zencoder
This step is optional, would you like to perform it? (Y/N): N
== Completed Zencoder
== Starting Misc
Cool check it value: w00t
== Completed Misc
== Running db:setup
...
== Completed db:setup
== All done!
Run rails s and sidekiq to get rolling!
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[s3]: http://github.com/patbenatar/stairs-steps-s3
[balanced]: http://github.com/patbenatar/stairs-steps-balanced
[facebook]: http://github.com/patbenatar/stairs-steps-facebook

## Credits

### Contributors

* [Nick Giancola](https://github.com/patbenatar)
* [Brendan Loudermilk](https://github.com/bloudermilk)

### Sponsor

[![philosophie](http://patbenatar.github.io/showoff/images/philosophie.png)](http://gophilosophie.com)

This gem is maintained partially during my open source time at [philosophie](http://gophilosophie.com).
