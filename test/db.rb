require 'active_record'

module DB

class Aggregation < ActiveRecord::Base
  has_many :aggregations, as: :child
  belongs_to :aggregation, as: :parent_id
  has_and_belongs_to_many :elements
end

class Element < ActiveRecord::Base
  has_and_belongs_to_many :aggregations
  belongs_to :tax
end

class Tax < ActiveRecord::Base
  has_many :elements
  has_many :aggregations
end

def self.establish_test_connection
  ActiveRecord::Base.establish_connection(
   adapter: 'sqlite3',
   database: 'test-menu-chatbot.db'
  )
end

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
      t.integer "aggregation_id"
      t.index ["aggregation_id"], name: "index_aggregations_on_aggregation_id"
    end
  end
end

class CreateAggregationsElementsTable < ActiveRecord::Migration[5.2]
  def change
    create_table "aggregations_elements", id: false, force: :cascade do |t|
      t.integer "aggregation_id", null: false
      t.integer "element_id", null: false
      t.index ["aggregation_id", "element_id"], name: "index_aggregations_elements_on_aggregation_id_and_element_id"
      t.index ["element_id", "aggregation_id"], name: "index_aggregations_elements_on_element_id_and_aggregation_id"
    end
  end
end

class CreateTaxesTable < ActiveRecord::Migration[5.2]
  def change
    create_table "taxes", force: :cascade do |t|
      t.string "name"
      t.float "qty"
      t.integer "merchant_id"
      t.index ["merchant_id"], name: "index_taxes_on_merchant_id"
    end
  end
end

def self.initialize(test=false)
  establish_test_connection

  # Create the table
  CreateElementsTable.migrate(:up)
  CreateAggregationsTable.migrate(:up)
  CreateAggregationsElementsTable.migrate(:up)
  CreateTaxesTable.migrate(:up)
end

end  # module DB