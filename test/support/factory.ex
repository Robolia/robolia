defmodule GameRoom.Factory do
  use ExMachina.Ecto, repo: GameRoom.Repo
  alias GameRoom.Games.TicTacToes.TicTacToe
  alias GameRoom.Accounts.User

  def user_factory do
    %User{
      auth_key: sequence("auth_key")
    }
  end

  def tic_tac_toe_factory do
    %TicTacToe{
      first_player_id: build(:user).id,
      second_player_id: build(:user).id,
      next_player_id: nil,
      winner_id: nil
    }
  end
end
