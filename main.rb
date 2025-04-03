#!/usr/bin/env ruby
require_relative 'Domain/Additional_Charges/Calculator/calculator.rb'
require_relative 'Domain/DataHandler/facade.rb'
require_relative 'Domain/DataHandler/io_handler.rb'
require_relative 'Implementation/DataHandler/json_handler.rb'
require_relative 'Implementation/Additional_Charges/calculator/tax_calculator.rb'
require_relative 'Implementation/Additional_Charges/calculator/Decorators/abstract_tax_calculator_decorator.rb'
require_relative 'Implementation/Additional_Charges/calculator/Decorators/mod_calculator.rb'
require_relative 'Implementation/DataHandler/tax_config_facade.rb'
require_relative 'Implementation/DataHandler/Decorators/base_tax_config_facade_decorator.rb'
require_relative 'Implementation/DataHandler/Decorators/mod_tax_config_facade_decorator.rb'


# Global variables 
$NO_CHANGE = 1.0 #represents no change when multiplied
$DEFAULT_PRECISION = 5 #to avoid floating point errors for financial calculations

# Get the tax_rules
file_path = 'config/tax_config.json'

data_handler = JSONHandler.new()

ds1 = TaxConfigFacade.new(file_path,data_handler)

data_source = ModificationTaxFacadeDecorator.new(ds1)



# Example item to test the calculator
items = { "price" => 142.75, "tags" => ["perfume"], "imported" => true }

# Create a TaxCalculator instance with the tax_config
calculator = TaxCalculator.new(data_source)

# Calculate the tax and display it
taxes = calculator.calculate(items)
puts "The calculated tax is: $#{format('%0.2f',taxes)}"