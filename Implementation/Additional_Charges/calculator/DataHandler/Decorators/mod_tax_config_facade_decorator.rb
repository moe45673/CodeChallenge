class ModificationTaxFacadeDecorator < AbstractTaxConfigFacadeDecorator 

  def get(item)


    this_taxes = @baseclass.get(item)


    mods = { "modifications" => []}

    this_taxes["taxes"].map do |tax|
      tax_type = tax["type"]

      @config["modifications"].select do |mod|    

        mods["modifications"] << mod if 
          mod["affected_tax"] == tax_type && 
          applies?(mod["condition"], item)   
      end         
    end
    this_taxes.merge!(mods)  
  end
end