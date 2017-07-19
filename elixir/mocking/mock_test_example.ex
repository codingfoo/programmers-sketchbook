defmodule SomeMockModule do
end

defmodule MockUtil do
  defmacro add_mock module, block do
    # magic
  end
end

defmodule Test do
  require MockUtil

  MockUtil.add_mock SomeMockModule do
    def some_func do
      "mock value"
    end
  end

  test "The mock value is returned" do
    assert SomeMockModule.some_func == "mock value"
  end
end


