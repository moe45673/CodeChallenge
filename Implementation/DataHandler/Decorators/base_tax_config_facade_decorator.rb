class AbstractTaxCalculatorDecorator < TaxCalculator
  
  def initialize(taxCalc)
    @baseclass = taxCalc
    @data_source = @baseclass.data_source
  end

  def calculate_tax(item,tax,rate)    
    raise NotImplementedError, "Subclasses must implement calculate_tax(item)"
  end


end