class AbstractTaxConfigFacadeDecorator < TaxConfigFacade
  
  def initialize(taxCalc)
    @baseclass = taxCalc
    @config = @baseclass.config
  end

  def get(item)    
    raise NotImplementedError, "Subclasses must implement get(item)"
  end


end