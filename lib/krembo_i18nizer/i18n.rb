module I18n
  class << self
    # point current self.translate() to self.__translate()
    alias :__translate :translate 
    # override self.translate()
    def translate(key, options = {})
      return "{%'key':'#{key}','value':'#{self.__translate(key, {})}'%}"
    end
  end
end
