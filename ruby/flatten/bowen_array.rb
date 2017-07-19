class Array
  def bowen_flatten
    new_array = Array.new

    for element in self do
      if element.is_a? Array
        new_array.concat element.bowen_flatten 
      else
        new_array << element 
      end
    end

    new_array
  end

  def bowen_flatten!
    return nil if self.empty? 

    #test for edgecase of array containing no sub arrays
    return nil if self.select { |element| true if element.is_a?(Array) }.empty?

    new_array = self.clone
    self.clear

    for element in new_array do
      if element.is_a? Array
        self.concat element.bowen_flatten 
      else
        self << element 
      end
    end

    self #ensure return is same as flatten!  
  end
end

