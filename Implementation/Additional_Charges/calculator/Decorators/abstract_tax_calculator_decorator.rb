class AbstractTaxCalculatorDecorator < TaxCalculator
 
 def initialize(taxCalc)
   @baseclass = taxCalc
   @data_source = taxCalc.data_source
 end

 def calculate_tax(item)   
  raise NotImplementedError, "Subclasses must implement calculate_tax(item)"
 end
end