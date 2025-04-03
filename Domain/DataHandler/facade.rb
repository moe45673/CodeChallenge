module Facade
  # Get entities that apply to the item
  def get(item)
   raise NotImplementedError, "Subclasses must implement get(item)"
  end

  protected

  # Check if a condition applies to an item
  def applies?(condition, item)
raise NotImplementedError, "Subclasses must implement applies?(condition, item)"
  end

  # Normalize values for consistent comparison
  def normalize(item)
    raise NotImplementedError, "Subclasses must implement  def normalize(item)"
  end
end