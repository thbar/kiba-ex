defmodule KibaTest do
  use ExUnit.Case

  test "source declaration" do
    defmodule SimpleETL do
      use Kiba
      source EnumerableSource, (1..10)
    end
    assert [klass: EnumerableSource, options: (1..10)] == Enum.at(SimpleETL.sources, 0)
  end
end
