defmodule MockUtil do
  defmacro __using__(:mock) do
    Module.register_attribute __MODULE__,
        :functions,
        accumulate: true, persist: false

    Module.put_attribute __MODULE__, {__MODULE__, :define_functions}
  end

  defmacro __using__(:test) do
  end

  defmacro register_function( module, do: block )do
    Module.put_attribute module, :functions, block
  end

  defmacro define_functions(_env) do
    @functions
  end
end

defmodule Test do
  use MockUtil, :test

  MockUtil.register_function Mock do
    def foo_bar do
      IO.puts "Inside foo_bar."
    end
  end
end

defmodule Mock do
  use MockUtil, :mock
end

Mock.foo_bar
