defmodule Agala.Provider.ViberTest do
  use ExUnit.Case
  doctest Agala.Provider.Viber
  @tag :skip
  test "greets the world" do
    assert Agala.Provider.Viber.hello() == :world
  end
end
