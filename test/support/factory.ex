defmodule Robolia.Factory do
  use ExMachina.Ecto, repo: Robolia.Repo
  alias Robolia.Games.TicTacToes.{TicTacToeMatch, TicTacToeMoviment}
  alias Robolia.Games.Game
  alias Robolia.Accounts.{User, Player}

  def user_factory do
    %User{
      name: sequence("Name")
    }
  end

  def game_factory do
    %Game{
      name: sequence("game_"),
      slug: sequence("game-")
    }
  end

  def player_factory do
    %Player{
      repository_url: sequence("url_"),
      language: "elixir",
      game_id: build(:game).id,
      user_id: build(:user).id,
      active: false
    }
  end

  def tic_tac_toe_match_factory do
    %TicTacToeMatch{
      first_player_id: build(:player).id,
      second_player_id: build(:player).id,
      next_player_id: nil,
      winner_id: nil
    }
  end

  def tic_tac_toe_moviment_factory do
    match = build(:tic_tac_toe_match)

    %TicTacToeMoviment{
      position: 1,
      tic_tac_toe_match_id: match.id,
      player_id: match.first_player_id
    }
  end
end
