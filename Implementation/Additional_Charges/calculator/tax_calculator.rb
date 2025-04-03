# tax_calculator/calculator.rb
class TaxCalculator
  include Calculator

  def initialize(tax_config)

    @rates = tax_config["rates"] 

    @taxes = tax_config["taxes"]

    @modifications = tax_config["modifications"].group_by { |m| m["affected_tax"] }
  end

  def calculate_taxes(item)
    total_tax_rate = 0.0
    @taxes.each do |tax|
      rate = @rates[tax["type"]] || 0.0 #default value
      total_tax_rate += calculate_tax(item, tax, rate, &method(:calculate_modifications)) 
    end

    price = item["price"]
    total_tax_rate = total_tax_rate.round($DEFAULT_PRECISION) #rounded so as not to have floating point issues

    dollar_value =total_tax_rate * price
    rounded_dollar = (dollar_value / 0.05).ceil * 0.05
    
    return rounded_dollar
  end

  protected

  def calculate_tax(item,tax,rate,&get_mods)    
   
    modified_rate = 0.0
    if applies?(tax["condition"], item)
      tax_type = tax["type"]    
      modified_rate = get_mods.call(item, tax_type, rate) || rate
    end
    return modified_rate 
  end

  def calculate_modifications(item, tax_type, rate)
    mTaxType = @modifications[tax_type]
    (mTaxType || []).each do |mod|
      rate *= calculate_modification(item, tax_type, mod)
    end
    return rate
  end

  def calculate_modification(item, tax_type, mod)
    if mod_applies?(tax_type, mod, item)
        return mod["value"] || $NO_CHANGE
    end
    $NO_CHANGE
  end

  private

  def applies?(condition, item)
    key = condition["key"]
    return true if key == "always"
          
    expected_value = Array(condition["value"])  # e.g. [true], ["book"]
    actual_value = Array(item[key])
    # check if there's any intersection, if true then it applies
    (normalize(actual_value) & normalize(expected_value)).any?     
  end

  def mod_applies?(tax_type, mod, item)
    (mod["affected_tax"] == tax_type) && 
      (applies?(mod["condition"], item))

  end

  def normalize(obj)
    obj.is_a?(Array) ? 
      obj.map{ |v| normalize(v)} : 
      obj.to_s.downcase
  end


end

