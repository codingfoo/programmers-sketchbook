defmodule MockUtil do
  defmacro add_mock module, block do
    quote context: SomeMockModule do
      def some_func do
        "mock value"
      end
    end
  end
end

defmodule Test do
  require MockUtil

  MockUtil.add_mock SomeMockModule do
    def some_func do
      "mock value"
    end
  end

  def foo do
    SomeMockModule.some_func |> IO.inspect
  end
end

defmodule SomeMockModule do
end

Test.foo


