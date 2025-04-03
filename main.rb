#!/usr/bin/env ruby
require 'json'
require_relative 'tax_calculator/calculator'

# Global variables 
$NO_CHANGE = 1.0 #represents no change when multiplied
$DEFAULT_PRECISION = 5 #to avoid floating point errors for financial calculations

# Get the tax_rules
file_path = 'config/tax_config.json'

tax_config_json = File.read(file_path)

tax_config = JSON.parse(tax_config_json)

# Example item to test the calculator
item = { "price" => 142.75, "tags" => ["perfume"], "imported" => true }

# Create a TaxCalculator instance with the tax_config
calculator = TaxCalculator.new(tax_config)

# Calculate the tax and display it
taxes = calculator.calculate_taxes(item)
puts "The calculated tax is: $#{format('%0.2f',taxes)}"