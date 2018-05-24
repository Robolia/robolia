{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(GameRoom.Repo, :manual)

Mox.defmock(GameRoom.PlayerContainerMock, for: GameRoom.PlayerContainer)
