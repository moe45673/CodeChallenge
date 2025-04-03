module IOHandler
  
  def read(input)
   
    raise NotImplementedError, "Subclasses must implement read(input)"
     
  end

  def write(output)
   
    raise NotImplementedError, "Subclasses must implement write(output)"
     
  end

end