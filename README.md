# DepUpdater

Dep Updater is a project to handle when you push a new version of a gem. It will update all projects that depend on that gem under a new branch and push to the origin repository. Ultimately, if you have your SCM Host setup correctly, this will kick of a CI build.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dep_updater'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dep_updater

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dep_updater/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
