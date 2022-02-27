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

- Read **Usage** section to know how to define the classes to use this gem.
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

# Usage

The basic idea here is to define a json file with the objects that must be inserted into the database.

Before using this functionality, the database connection must be set using `active_record`. If you are using Rails, then no more code is needed, becouse Rails already manage the connection. If you are not using Rails, you can create a database connection directly from code.

Sample:

```ruby
require 'active_record'
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'test-menu-chatbot.db'
)
```
Then create the tables with migrations:

```ruby
class CreateElementsTable < ActiveRecord::Migration[5.2]
  def change
    create_table "elements", force: :cascade do |t|
      t.string "name"
      t.decimal "price", precision: 8, scale: 2
      t.integer "tax_id"
      t.index ["tax_id"], name: "index_elements_on_tax_id"
    end
  end
end

class CreateAggregationsTable < ActiveRecord::Migration[5.2]
  def change
    create_table "aggregations", force: :cascade do |t|
      t.string "name"
      t.integer "parent_id"
      t.index ["parent_id"], name: "index_aggregations_on_aggregation_id"
    end
  end
end

CreateElementsTable.migrate(:up)
CreateAggregationsTable.migrate(:up)
```

Also you must define the `ActiveRecod` subclasses specifiying the models:

```ruby
class Aggregation < ActiveRecord::Base
  has_many :childs, class_name: "Aggregation"
  belongs_to :parent, class_name: "Aggregation"
  has_and_belongs_to_many :elements
end

class Element < ActiveRecord::Base
  has_and_belongs_to_many :aggregations
  belongs_to :tax
end
```

Once created the database connection and tables exists, you can load a json file, by doing:

```ruby
jsonFile = IO.read("./test/menu.json")
json = JSON.parse(jsonFile)
```

## How to define the json file

The root of the json object must be several pairs (name, arrays) with the main data to be loaded. If you want to add rows to a table using a model, set the name of the pair to the name of the model in plural, like:

```json
{
	aggregations: [...]
}
```

Then ser all the objects in the array, like:

```json
{
	aggregations: [{
		"id": 1,
		"name": "Complement",
		"parent_id": null,
	}, {
		"id": 2,
		"name": "Fries",
		"parent_id": 1
	}]
}
```

`has_one` and `belongs_to` can be defined by setting the name of the assiciation in the json object, like the previous example: `"parent_id": 1`

If you want to set `has_many` or `has_and_belongs_to_many` associations, you must set the name of the association in the json object in plural and define an array with the `id` of the linked objects, like:

```json
{
	"aggregations": [{
		"id": 1,
		"name": "Drink",
		"parent_id": null,
		"elements": [1, 2]
	}, {
		"id": 2,
		"name": "Complement",
		"parent_id": null,
		"elements": [8, 9, 10]
	}]
}
```

Then you can define more objects by adding other pairs to the root of the json object:

```json
{
	"aggregations": [{
		"id": 1,
		"name": "Drink",
		"parent_id": null,
		"elements": [1, 2]
	}, {
		"id": 2,
		"name": "Complement",
		"parent_id": null,
		"elements": [8, 9, 10]
	}],
	"elements": [{
		"id": 1,
		"name": "Ice water",
		"price": "12.3",
		"tax_id": null
	}, {
		"id": 2,
		"name": "Water",
		"price": "0.9",
		"tax_id": null
	}]
}
```
