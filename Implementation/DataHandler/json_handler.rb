require 'json'

class JSONHandler
  include IOHandler

  def read(input)
    JSON.parse(File.read(input))
  end

  def write(output)
    puts << "written!"   
  end

end