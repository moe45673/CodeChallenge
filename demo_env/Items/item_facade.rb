require 'json'

class ItemDataFacade
  def initialize(file_path)
    @file_path = file_path
    @items = load_items
  end

  

  def get(passed_item)
    
    passed_item["imported"] = 
        passed_item["imported"] == "imported" 



    item = @items.find { 
      |i| (
        i["name"] == passed_item["name"] || i["plural"] == passed_item["name"]) && 
        i["imported"] == passed_item["imported"] 
       }
    return nil unless item

    {
      "name" => passed_item["name"],
      "imported" => item["imported"],
      "tags" => item["tags"],
      "price" => passed_item["price"]
    }
  end

  private

  def load_items
    return [] unless File.exist?(@file_path)
    JSON.parse(File.read(@file_path))
  end
end


private

#quick and dirty, as I can't use Rails to singularize
def singularize(name)
  if name == "boxes of chocolates"
    "box of chocolates"
  end
end