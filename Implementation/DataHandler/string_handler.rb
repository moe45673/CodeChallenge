class StringHandler
  include IOHandler

    def initialize(regex)
      @regex = Regexp.new(regex)
    end

  def read(file_path)
    return [] unless File.exist?(file_path)
    File.readlines(file_path, chomp: true).map do |line|
      match = @regex.match(line.strip)
      if match
        captures = match.named_captures
        # Trim whitespace from all string values
        captures.transform_values! { |v| v.is_a?(String) ? v.strip : v }
      else
        nil
      end
    end.compact
  end

  def write(file_path, content)
    File.write(file_path, content)
  end

end