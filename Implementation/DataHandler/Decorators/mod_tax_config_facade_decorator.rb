class ModificationTaxFacadeDecorator < AbstractTaxCalculatorDecorator 

  def get(item)
    this_taxes = super

    mods = { "modifications" => []}

    this_taxes.map do |tax|
      tax_type = tax["type"]

      @config["modifications"].select do |mod|    

        mods["modifications"] << mod if mod["affected_tax"] == 
          tax_type && applies?(mod["condition"], item)   

      this_taxes[] << mods  
      end

    end
  end
end