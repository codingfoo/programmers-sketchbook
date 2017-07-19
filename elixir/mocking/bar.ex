defmodule MockUtil do
  defmacro __using__(_opts) do
    IO.inspect "===using"
    quote do
      Module.register_attribute Mock,
          :functions_attr,
          accumulate: true, persist: false

      defmacro define_functions(_env) do
        @functions_attr
      end
    end
  end

  defmacro add_mock_function( module, do: block )do
    IO.inspect "===add_mock_function"
    module_name = Macro.expand_once module, __CALLER__
    #Module.put_attribute module_name, :functions_attr, block
    Mock.put_attribute
    nil
  end

end

defmodule Test do
  use MockUtil
  # how to mock multiple modules

  MockUtil.add_mock_function Mock do
    def foo_bar do
      IO.puts "inside foo_bar"
    end
  end
end

defmodule Mock do
  defmacro put_attribute do
    IO.inspect "inside put"
    Module.put_attribute Mock, :functions_attr, "var"
    nil
  end
  @before_compile {Test, :define_functions}
  #how to get functions from multiple modules
end

Mock.foo_bar
