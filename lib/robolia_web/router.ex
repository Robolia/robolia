defmodule RoboliaWeb.Router do
  use RoboliaWeb, :router

  pipeline :browser do
    # Disabled because of bug with CSRF check: https://github.com/ueberauth/ueberauth_github/issues/69#issuecomment-1630805292
    # plug Ueberauth
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RoboliaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RoboliaWeb do
    pipe_through :browser

    get "/", HomeController, :index
  end

  scope "/auth", RoboliaWeb do
    pipe_through(:browser)
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end

  scope "/account", RoboliaWeb do
    pipe_through(:browser)
    get("/", AccountController, :index)

    get("/players/new", PlayersController, :new)
    get("/players/new/:game_slug", PlayersController, :new_for_game)
    put("/players/:id", PlayersController, :update)
  end

  scope "/matches", RoboliaWeb do
    pipe_through(:browser)
    get("/", MatchesController, :index)
    get("/user/latests", MatchesController, :user_latests)
    get("/tic_tac_toes/:match_id", TicTacToesController, :show)
  end

  scope "/github", RoboliaWeb do
    pipe_through(:api)
    post("/fork", GithubForkController, :create)
  end

  # Other scopes may use custom stacks.
  # scope "/api", RoboliaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:robolia, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RoboliaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
