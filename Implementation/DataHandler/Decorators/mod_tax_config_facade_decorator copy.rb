class ModificationTaxFacadeDecorator < AbstractTaxFacadeDecorator 
 
 def initialize(tcf)
   @baseclass = tcf
   super(tcf.config_path)
 end

 def get(item)
   
  taxes = super

  mods = @config["modifications"].select do |mod|
    mod["affected_tax"] == tax_type && applies?(mod["condition"], item)

  taxes.map
  
 end

protected




end