defmodule KibaTest do
  use ExUnit.Case

  test "source declaration" do
    defmodule SourceDeclarationETL do
      use Kiba
      source EnumerableSource, (1..10)
    end
    assert [klass: EnumerableSource, options: (1..10)] == Enum.at(SourceDeclarationETL.sources, 0)
  end
  
  test "transform declaration" do
    defmodule TransformDeclarationETL do
      use Kiba
      transform SomeTransform, foo: "value", bar: "value"
    end
    assert [klass: SomeTransform, options: [foo: "value", bar: "value"]] == Enum.at(TransformDeclarationETL.transforms, 0)
  end
  
  test "destination declaration" do
    defmodule DestinationDeclarationETL do
      use Kiba
      destination SomeDestination, foo: "bar"
    end
    assert [klass: SomeDestination, options: [foo: "bar"]] == Enum.at(DestinationDeclarationETL.destinations, 0)
  end
end
