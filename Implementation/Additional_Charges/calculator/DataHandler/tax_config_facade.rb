class TaxConfigFacade
  include Facade
  attr_reader :config
  
  def initialize(config_path, data_handler)
    @config_path = config_path
    @config = data_handler.read(config_path)
  end

  # Get taxes that apply to the item
  def get(item)
    taxes = @config["taxes"].select { |tax| applies?(tax["condition"], item) } 
    rates = config["rates"]
    tax_header = {"taxes" => []  }
    taxes.map do |tax|
      tax_entry = {
        "type" => tax["type"],
        "rate" => rates[tax["type"]] || 0.0,
        "condition" => tax["condition"]
      }
      tax_header["taxes"] << tax_entry
    end
    return tax_header
  end


  protected

  # Check if a condition applies to an item
  def applies?(condition, item)
    key = condition["key"]
    return true if key == "always"
          
    expected_value = Array(condition["value"])  # e.g. [true], ["book"]
    actual_value = Array(item[key.to_s])
    # check if there's any intersection, if true then it applies
    (normalize(actual_value) & normalize(expected_value)).any?     
  end

  # Normalize values for consistent comparison
  def normalize(item)
    if item.is_a?(Array)
      item.map { |v| normalize(v) }
    else
      item.to_s.downcase
    end
  end
end