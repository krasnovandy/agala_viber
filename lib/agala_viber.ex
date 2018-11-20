defmodule Agala.Provider.Viber do
  use Agala.Provider

  def get_bot(:plug), do: Agala.Provider.Viber.Plug
end
