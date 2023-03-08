class EnsureUtf8Encode

  def initialize(string)
    @string = string
  end

  def process
    @string = @string.scrub
    @string = @string.each_char.select{|c| c.bytes.first < 240 }.join('')
    return @string
  end

end
