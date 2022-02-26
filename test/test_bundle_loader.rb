require 'minitest/autorun'
require 'json'
require 'bundle_loader'
require 'db'

class BundleLoaderTest < Minitest::Test
  def test_load_json_file
    jsonFile = IO.read("./test/menu.json")
    refute_nil "hello world", JSON.parse(jsonFile)
  end

  def test_load_json_file_check_values
    jsonFile = IO.read("./test/menu.json")
    json = JSON.parse(jsonFile)
    assert_equal 5, json["aggregations"].count
    assert_equal 15, json["elements"].count
    assert_equal 1, json["taxes"].count
  end

  def test_load_json_into_database
    jsonFile = IO.read("./test/menu.json")
    json = JSON.parse(jsonFile)
    DB.initialize
    BundleLoader.load(json)
  end
end