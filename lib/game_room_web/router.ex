defmodule GameRoomWeb.Router do
  use GameRoomWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", GameRoomWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", HomeController, :index)
  end

  scope "/auth", GameRoomWeb do
    pipe_through(:browser)

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end

  scope "/account", GameRoomWeb do
    pipe_through(:browser)

    get("/", AccountController, :index)
    get("/players/new", PlayersController, :new)
    post("/players", PlayersController, :create)
    get("/players", PlayersController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", GameRoomWeb do
  #   pipe_through :api
  # end
end
