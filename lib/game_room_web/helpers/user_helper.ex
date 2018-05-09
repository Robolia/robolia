defmodule GameRoomWeb.Helpers.UserHelper do
  import Enum, only: [at: 2]

  def user_name(user) do
    names = user.name |> String.split(" ")

    case names |> length do
      names_count when names_count > 2 ->
        "#{at(names, 0)} #{at(names, 1)}"

      _ ->
        user.name
    end
  end
end
