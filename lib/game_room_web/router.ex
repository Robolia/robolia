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
    get("/players/new/:game_slug", PlayersController, :new_for_game)
    put("/players/:id", PlayersController, :update)
  end

  scope "/matches", GameRoomWeb do
    pipe_through(:browser)
    get("/", MatchesController, :index)
    get("/user/latests", MatchesController, :user_latests)
    get("/tic_tac_toes/:match_id", TicTacToesController, :show)
  end

  scope "/github", GameRoomWeb do
    pipe_through :api
    post("/fork", GithubForkController, :create)
  end


  # Other scopes may use custom stacks.
  # scope "/api", GameRoomWeb do
  #   pipe_through :api
  # end
end
