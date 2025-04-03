class AbstractTaxFacadeDecorator < TaxConfigFacade 
 
 def initialize(tcf)
   @baseclass = tcf
   super(tcf.config_path)
 end

 def get(item)
   raise NotImplementedError, "Subclasses must implement get(item)"
 end

 

end