# Stairs

A DSL and collection of plugins for easy setup of projects on new development
environments.

## Setup

1. Install gem `stairs`

1. Require tasks in Rakefile
```ruby
require "stairs/tasks"
```

1. Define `setup.rb` in the root of your project

## Usage

In an app with a `setup.rb`, just run the rake task:

```
$ rake newb
```

## Defining scripts

A script composes many steps that setup a project.

```ruby
setup :secret_token

setup :s3
setup :zencoder, required: false

env "CHECK_IT", provide "Cool check it value"

puts "Sweet you're good to go. Just run `rails s` and `sidekiq` to get rolling!"
```

### Example CLI

Given the above script, the CLI would look like this:

```
$ rake newb
... bundle install
... db setup + seed

== Starting S3 Setup
AWS access key: 39u39d9u291
AWS secret: 19jd920i10is0i01i0s01ks0kfknkje
Do you have an existing bucket? (Y/N): Y
Bucket name (leave blank for app-dev): my-cool-bucket

== Starting Zencoder
This step is optional, would you like to perform it? (Y/N): N

== Starting misc
Cool check it value: w00t

== All done!
Run rails s and sidekiq to get rolling!
```

## DSL

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
```ruby
env "NAME", value
```

### Writing files
```ruby
write "awesome: true", "config/settings.yml"
write_line "more: false", "config/settings.yml"
```

### Defining setup steps
```ruby
setup :a_cool_service do
  ## ..
end
```

#### Using predefined steps
```ruby
setup :s3
```

## Plugins for common setups

```ruby
require "fog"
class S3Setup < Stairs::Step
  title "S3"
  description "Setup AWS tokens and bucket"

  def run
    @key = provide "AWS access key"
    @secret = provide "AWS secret"

    choice "Do you have an existing bucket?" do |yes|
      env "S3_BUCKET", if yes
        provide "Bucket name", default: "app-dev"
      else
        create_bucket
      end
    end

    env "AWS_ACCESS_KEY", @key
    env "AWS_SECRET", @secret
  end

  private

  def create_bucket
    # use @key and @secret to create bucket via API
  end
end
```

## To think about...

* How to manage gem dependencies (S3Setup for example requires fog to be
  installed)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
