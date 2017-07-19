ExUnit.start

defmodule MockUtil do
  defmacro __using__(_opts) do
    quote do
      defmacro __using__(_env) do
        test_module = __MODULE__
        mock_module = __CALLER__.module
                      |> Atom.to_string
                      |> String.downcase
                      |> String.split(".")
                      |> tl
        name = "#{mock_module}_functions_attr" |> String.to_atom
        quote do
          unquote(test_module).unquote(name)()
        end
      end
    end
  end

  defmacro add_mock_function( module, do: block ) do
    mock_module = Macro.expand_once( module, __CALLER__)
                  |> Atom.to_string
                  |> String.downcase
                  |> String.split(".")
                  |> tl

    test_module = __CALLER__.module
    functions_attribute = "#{mock_module}_functions_attr" |> String.downcase |> String.to_atom

    first_time? = Module.get_attribute test_module, functions_attribute

    Module.register_attribute test_module,
        functions_attribute,
        accumulate: true, persist: false

    Module.put_attribute test_module, functions_attribute, block

    if first_time? == nil do
      ast = {:@, [], [{functions_attribute, [], test_module}]}
      name = "#{mock_module}_functions_attr" |> String.to_atom
      quote do
        defmacro unquote(name)(), do: unquote(ast)
      end
    end
  end
end

defmodule Test do
  use ExUnit.Case
  use MockUtil


  MockUtil.add_mock_function Mock do
    def foo do
      "Inside foo."
    end
  end

  test "Register function adds foo function" do
    assert  "Inside foo." == Mock.foo
  end

  MockUtil.add_mock_function Mock do
    def bar do
      "Inside bar."
    end
  end

  test "Register function adds bar function" do
    assert  "Inside bar." == Mock.bar
  end

  MockUtil.add_mock_function MockAgain do
    def baz do
      "Inside bar."
    end
  end

  test "Register function adds baz function" do
    assert  "Inside bar." == MockAgain.baz
  end
end

defmodule Mock do
  use Test
end

defmodule MockAgain do
  use Test
end
