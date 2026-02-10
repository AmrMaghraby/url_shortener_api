  class CodeGenerator
    LENGTH = 6
    ALPHABET = (
      ("a".."z").to_a +
      ("A".."Z").to_a +
      ("0".."9").to_a
    ).freeze
  
    def self.generate
      Array.new(LENGTH) { ALPHABET.sample }.join
    end
  end
  