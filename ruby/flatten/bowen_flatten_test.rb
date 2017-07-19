require './bowen_array.rb'
require 'test/unit'

class Bowen_Flatten_Test < Test::Unit::TestCase
  def setup
    @example_array1 = [6, 10, 3]
    @example_array2 = [8, 1, @example_array1, 2 ]
    @example_array3 = [7, 4, @example_array2, 9, 5 ]
    @example_array4 = [7, 4, [3, 6, [4, 20, 13, [5, 6, 10], 300 ], 42 ], 9, 5 ]
    @example_array5 = @example_array4.clone
  end

  def test_bowen_flatten
    assert_equal @example_array3.flatten, @example_array3.bowen_flatten
  end

  def test_bowen_flatten!
    @example_array4.flatten!
    @example_array5.bowen_flatten!
    assert_equal @example_array4, @example_array5
  end

  def with_empty_array_test_bowen_flatten!
    empty_array1 = []
    empty_array2 = []
    empty_array1.flatten!
    empty_array2.bowen_flatten!
    assert_equal empty_array1, empty_array2
  end
  
  def with_array_containing_no_subarrays_test_bowen_flatten!
    array_without_subarrays1 = [ 1, 3, 5 ]
    array_without_subarrays2 = array_without_subarrays1.clone
    array_without_subarrays1.flatten!
    array_without_subarrays2.bowen_flatten!
    assert_equal array_without_subarrays1, array_without_subarrays2 
  end
end
