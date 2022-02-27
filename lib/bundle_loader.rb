require 'active_record'
require 'json'

# Load json data into database
class BundleLoader
  # Load json data into database using ActiveRecord.
  # ActiveRecord subclasses are discovered by looking
  # at the base object names in the json data.
  #
  # Each object is loaded into a table in a first step.
  # Then, the relationships between the objects are loaded.
  #
  # Example:
  #   >> file = IO.read("./test/menu.json")
  #   >> json = JSON.parse(file)
  #   >> BundleLoader.load(json)
  #   => {}
  #
  # Arguments:
  #   jsonData: (JSON)
  def self.load(jsonData)
    load_raw_objects(jsonData)
    link_objects(jsonData)
  end

  def self.load_raw_objects(jsonData)
    # Create the objects of each class
    jsonData.each_pair do |key, value|
      next if !value.is_a?(Array)  # Skip if the value is not an array
      tableName = key.to_s.pluralize
      tableClass = tableName.classify.constantize
      value.each do |object|
        # Remove all the field that are arrays
        object = object.filter { |k, v| !v.is_a?(Array) }
        tableClass.create(object)
      end
    end
  end

  def self.link_objects(jsonData)
    # Link the objects of each class
    jsonData.each_pair do |key, value|
      next if !value.is_a?(Array)  # Skip if the value is not an array
      tableName = key.to_s.pluralize
      tableClass = tableName.classify.constantize
      value.each do |object|
        baseObject = tableClass.find_by(id: object["id"])
        # Remove all the field that are not arrays
        object = object.filter { |k, v| v.is_a?(Array) }
        object.each_pair do |k, v|
          linkedObjectName = k.to_s
          linkedObjectClass = linkedObjectName.classify.constantize
          v.each do |linkedObjectId|
            linkedObject = linkedObjectClass.find(linkedObjectId)
            baseObject.send(linkedObjectName).push(linkedObject)
            baseObject.save
          end
        end
      end
    end
  end
end