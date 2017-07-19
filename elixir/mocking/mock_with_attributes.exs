ExUnit.start

defmodule MockUtil do
  defmacro __using__(_options) do
    quote do
      Module.register_attribute __MODULE__, :functions, accumulate: true, persist: false
    end
  end

 defmacro register_function( _module, do: block ) do
   IO.inspect block
   #IO.inspect unquote(block)
   quote do
     #@functions unquote(block)
     @functions "foo"
   end
 end
end

defmodule Test do
  use ExUnit.Case
  use MockUtil

  @after_compile __MODULE__

  def __after_compile__(_env, _bytecode) do
    IO.inspect @functions
  end

  @functions "Inside Body"

  defmacro mock_functions(_env) do
    IO.inspect "==== Mock Functions"
    IO.inspect @functions
    @functions
  end

  MockUtil.register_function Test do
    def foo_bar do
      IO.puts "Inside foo_bar."
      "Inside foo_bar."
    end
  end

  test "Register function adds a function to the mocked lib" do
    assert  "Inside foo_bar." == Mock.foo_bar
  end
end

defmodule Mock do
  require Test
  @before_compile {Test, :mock_functions}
end

Mock.foo_bar
