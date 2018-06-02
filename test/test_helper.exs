{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Robolia.Repo, :manual)

Mox.defmock(Robolia.PlayerContainerMock, for: Robolia.PlayerContainer)
