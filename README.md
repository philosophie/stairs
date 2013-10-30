# Stairs

A DSL and collection of plugins for easy setup of projects on new development
environments. Write a script that new devs can run for an interactive setup.
For environment variables, Stairs supports rbenv-vars, RVM, and dotenv.

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

In an app with a `setup.rb`, just run the rake task:

```
$ rake newb
```

## Defining scripts

A script composes many steps that setup a project. __Note:__ optional steps are
not yet implemented.

```ruby
bundle

setup :secret_token

setup :s3
setup :zencoder, required: false

setup :misc do
  env "CHECK_IT", provide "Cool check it value"
end

rake "db:setup"

finish "Just run rails s and sidekiq to get rolling!"
```

### Example CLI

Given the above script, the CLI might look like this. __Note:__ some of this
is desired future functionality (bundle/db tasks, spacing, last words).

```
$ rake newb
Looks like you're using rbenv to manage environment variables. Is this correct? (Y/N): Y

= Running script setup.rb

== Running bundle
...
== Completed bundle

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

## DSL

### Collecting values
```ruby
value = provide "Something"
value = provide "Another", required: false # Not fully implemented
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
```ruby
env "NAME", value
```

### Writing files
```ruby
write "awesome: true", "config/settings.yml"
write_line "more: false", "config/settings.yml"
```

### Misc helpers

Run bundle to install gems
```ruby
bundle
```

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
```

## Plugins for common setups

### Built-in
* `:secret_token` sets a secure random secret token

### Available as extension gems
* `:s3` interactive prompt for setting AWS + S3 bucket access credentials:
  [patbenatar/stairs-steps-s3][s3]
* `:balanced` automatically creates a test Marketplace on Balanced:
  [patbenatar/stairs-steps-balanced][balanced]
* `:facebook` interactive prompt for setting Facebook app credentials:
  [patbenatar/stairs-steps-facebook][facebook]

### Defining custom plugins

Steps inherit from `Stairs::Step`, have a title, description, and
implement the `run` method. See those included and in the various
extension gems for examples.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[s3]: http://github.com/patbenatar/stairs-steps-s3
[balanced]: http://github.com/patbenatar/stairs-steps-balanced
[facebook]: http://github.com/patbenatar/stairs-steps-facebook
