class AbstractTaxCalculatorDecorator < TaxCalculator
 
 def initialize(taxCalc)
   @baseclass = taxCalc
   @data_source = taxCalc.data_source
 end

 def calculate_tax(tax, data_source)   
  raise NotImplementedError, "Subclasses must implement calculate_tax(tax, data_source)"
 end
end