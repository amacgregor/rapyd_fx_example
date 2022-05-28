defmodule RapydFxExampleWeb.PageController do
  use RapydFxExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
