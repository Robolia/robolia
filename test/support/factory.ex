defmodule GameRoom.Factory do
  use ExMachina.Ecto, repo: GameRoom.Repo
  alias GameRoom.Games.TicTacToes.TicTacToe
  alias GameRoom.Accounts.{User, Player}

  def user_factory do
    %User{
      name: sequence("Name")
    }
  end

  def player_factory do
    %Player{
      repository: sequence("url_"),
      game: "tic_tac_toe",
      user_id: build(:user).id
    }
  end

  def tic_tac_toe_factory do
    %TicTacToe{
      first_player_id: build(:player).id,
      second_player_id: build(:player).id,
      next_player_id: nil,
      winner_id: nil
    }
  end
end
