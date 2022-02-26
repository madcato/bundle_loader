# BundleLoader

This gem allows to load json data into databases using Rails active_record.

## Doc 

This gem loads a json like this one:
```json
{
	"aggregations": [{
		"id": 1,
		"name": "Drink",
		"parent_id": null,
		"elements": [1, 2]
	}, ... ],
	"elements": [{
		"id": 1,
		"name": "Ice water",
		"price": "12.3",
		"tax_id": null
	}, ... ],
	"taxes": [{
		"id": 1,
		"name": "vat",
		"qty": 2.0
	}]
}
```

- Read [wiki] to know how to define the classes to use this gem.
- Also you can review the files `test/menu.json` and `test/db.rb`

## Intallation 

Add this line to your application's Gemfile:

```ruby
gem 'bundle_loader', :git => 'git://github.com/madcato/bundle_loader.git'
```

### Manual installation

    $ INSTALL_DIR=$HOME/.bender_loader sh <(curl -fsSL https://raw.githubusercontent.com/madcato/bundle_loader/master/install.sh)

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
