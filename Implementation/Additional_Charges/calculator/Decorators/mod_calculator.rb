class ModificationCalculator < AbstractTaxCalculatorDecorator


  def calculate_tax(item,tax,rate)    
    modified_rate = super
    tax_type = tax["type"]    
    modified_rate *= calculate_modification(item, tax_type, rate) || rate
    
  end

  def calculate_modification(mod)
      
    mod["value"] || $NO_CHANGE
    
  end

end