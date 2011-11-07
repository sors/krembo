class Hash
  def find_path(path)
    if path.class!=Array
      raise "Path is not an array"
    end
    leef = path.inject(self) do |location, key|
      location.respond_to?(:keys) ? location[key] : nil
    end
    leef
  end

  def replace_path(path,value)
    if (find_path(path).nil?)
      return false
    end
    last = path.pop
    leef = path.inject(self) do |location, key|
      location.respond_to?(:keys) ? location[key] : nil
    end
    puts leef.class
    leef[last] = value
    return true
  end
end