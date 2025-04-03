# tax_calculator/calculator.rb
class TaxCalculator
  include Calculator

  def initialize(data_source)
    @data_source = data_source
  end

  def calculate(item)
        
    tax_config = @data_source.get(item)

    taxes = tax_config["taxes"]
    total_tax_rate = 0.0
    taxes.each do |tax|
      rate = tax["rate"] || 0.0 #default value
      total_tax_rate += calculate_tax(item, tax, rate)
    end

    price = item["price"]
    total_tax_rate = total_tax_rate.round($DEFAULT_PRECISION) #rounded so as not to have floating point issues

    dollar_value =total_tax_rate * price
    rounded_dollar = (dollar_value / 0.05).ceil * 0.05
    
    return rounded_dollar
  end

  protected

  def calculate_tax(item,tax,rate)       
    rate
  end

  private

  def normalize(obj)
    obj.is_a?(Array) ? 
      obj.map{ |v| normalize(v)} : 
      obj.to_s.downcase
  end


end

