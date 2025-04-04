#!/usr/bin/env ruby
require_relative 'Domain/Additional_Charges/Calculator/calculator.rb'
require_relative 'Domain/DataHandler/facade.rb'
require_relative 'Domain/DataHandler/io_handler.rb'
require_relative 'Implementation/DataHandler/json_handler.rb'
require_relative 'Implementation/DataHandler/string_handler.rb'
require_relative 'Implementation/Additional_Charges/calculator/tax_calculator.rb'
require_relative 'Implementation/Additional_Charges/calculator/Decorators/abstract_tax_calculator_decorator.rb'
require_relative 'Implementation/Additional_Charges/calculator/Decorators/mod_calculator.rb'
require_relative 'demo_env/Items/item_facade.rb'
require_relative 'Implementation/Additional_Charges/calculator/DataHandler/tax_config_facade.rb'
require_relative 'Implementation/Additional_Charges/calculator/DataHandler/Decorators/base_tax_config_facade_decorator.rb'
require_relative 'Implementation/Additional_Charges/calculator/DataHandler/Decorators/mod_tax_config_facade_decorator.rb'
# Global variables 
$NO_CHANGE = 1.0 #represents no change when multiplied
$DEFAULT_PRECISION = 5 #to avoid floating point errors for financial calculations
$REGEX = '(?<quantity>\d+)\s+(?<imported>imported\s+)?(?<name>(\w+\s+)+)at\s+(?<price>\d+\.\d{2})'


class ReceiptCalculator

  def initialize
    file_path = 'demo_env/config/tax_config.json'
    item_file_path = 'demo_env/config/item_config.json'

    data_handler = JSONHandler.new()

    cf1 = TaxConfigFacade.new( file_path, data_handler )    

    @config_facade = ModificationTaxFacadeDecorator.new(cf1)

    # Create a TaxCalculator instance with the tax_config
    calc1 = TaxCalculator.new(@config_facade)
    @tax_calculator = ModificationCalculator.new( calc1 ) 

    # Regex to parse "quantity name at price" (e.g., "2 book at 12.49")
    @string_handler = StringHandler.new($REGEX)

    @item_facade = ItemDataFacade.new(item_file_path)

    @receipts = []  # Collection to store base prices and taxes
  end

  def run

    loop do
      puts "\nDo you want to:"
      puts "1) Calculate total cost"
      puts "2) Shutdown"
      print "Choice: "
      choice = gets.chomp

      case choice
      when "1"
        calculate_total_cost
      when "2"
        puts "Shutting down..."
        break
      else
        puts "Invalid choice. Please enter 1 or 2."
      end
    end
  end

  def calculate_total_cost
    @receipts = []
    file_path = pick_file
    return unless file_path

    line_items = @string_handler.read(file_path)
    line_items.each do |item|


      # Convert item data into the expected format
      processed_item = @item_facade.get(item)
      tax = @tax_calculator.calculate(processed_item)
      base_price = processed_item["price"]
      quantity = item["quantity"]
      @receipts << { "base_price" => base_price, "tax" => tax, "quantity" => quantity, "name" => item["name"], "imported" => item["imported"] }
    end

    @receipts.each do |entry|
      
      name = entry["name"]
      price = entry["base_price"].to_f
      tax = entry["tax"].to_f
      quantity = entry["quantity"].to_i
      imported = entry["imported"]
      entryprice_tax = quantity*(price + tax)
      puts "#{quantity} #{is_imported(imported)}#{name}: #{format('%.2f', entryprice_tax)}"
     
    end 

    total_base = @receipts.sum { |entry| entry["base_price"].to_f * entry["quantity"].to_i }
    total_tax = @receipts.sum { |entry| entry["tax"].to_f * entry["quantity"].to_i }
    puts "Sales Tax: #{format('%.2f', total_tax)}"
    puts "Total: #{format('%.2f', total_base + total_tax)}"
  end

  def is_imported(tf)
    tf ? "imported " : ""
  end

  def pick_file
    puts "Enter the input file path (or 'q' to cancel):"
    file_path = gets.chomp
    if file_path.downcase == 'q'
      puts "Cancelled."
      return nil
    elsif File.exist?(file_path)
      file_path
    else
      puts "File not found."
      nil
    end
  end
end

# Run the program
ReceiptCalculator.new.run