# BundleLoader

This gem allows to load json data into databases using Rails active_record.

## Intalation 

Add this line to your application's Gemfile:

```ruby
gem 'bundle_loader', :git => 'git://github.com/madcato/bundle_loader'
```

### Manual installation

    $ INSTALL_DIR=$HOME/.BenderButler sh <(curl -fsSL https://raw.githubusercontent.com/madcato/bundle_loader/master/install.sh)

## Building from code

Clone the repository:

    $ git clone https://github.com/madcato/bundle_loader.git
    $ cd bundle_loader

Build it:

    $ gem build bundle_loader.gemspec

Install it:

    $ gem install bundle_loader-*.gem

## Testing

Launch test:

    $ rake test
