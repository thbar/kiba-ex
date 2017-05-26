defmodule Kiba do
  defmacro __using__(_opts) do
    quote do
      import Kiba
      
      @sources []
      @transforms []
      @destinations []
      
      @before_compile Kiba
    end
  end

  defmacro source(klass, opts) do
    quote do
      @sources (@sources ++ [[klass: unquote(klass), options: unquote(opts)]])
    end
  end
  
  defmacro transform(klass, opts) do
    quote do
      @transforms (@transforms ++ [[klass: unquote(klass), options: unquote(opts)]])
    end
  end

  defmacro destination(klass, opts) do
    quote do
      @destinations (@destinations ++ [[klass: unquote(klass), options: unquote(opts)]])
    end
  end
  
  defmacro __before_compile__(_env) do
    quote do
      def sources do
        @sources
      end
      
      def run do
        Enum.each @sources, fn source ->
          klass = Keyword.fetch!(source, :klass)

          source
          |> Keyword.fetch!(:options)
          |> klass.stream
          |> Stream.map(fn(row) -> apply_transforms(row) end)
          |> Stream.map(fn(row) -> write_to_destinations(row) end)
          |> Stream.run
        end
      end
      
      def apply_transforms(row) do
        Enum.reduce(@transforms, row, fn(transform, acc) ->
          Keyword.fetch!(transform, :klass).process(acc)
        end)
      end
      
      def write_to_destinations(row) do
        Enum.each(@destinations, fn(destination) ->
          Keyword.fetch!(destination, :klass).write(row)
        end)
      end
    end
  end
end