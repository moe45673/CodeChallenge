class ModificationCalculator < AbstractTaxCalculatorDecorator


  def calculate_tax(tax, data_source)    
    modified_rate = @baseclass.calculate_tax(tax, data_source)
    mods = data_source["modifications"]
    
    
    mods.each do |mod|
      modified_rate *= calculate_modification(mod) if mod["affected_tax"] == tax["type"]
    end if mods
    
    return modified_rate
  end

  def calculate_modification(mod)
      
    mod["value"] || $NO_CHANGE
    
  end

end