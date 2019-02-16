import React from 'react';
import MatchSocket from '../services/MatchSocket';
import TicTacToeSquare from './TicTacToeSquare.jsx'

class TicTacToeBoard extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      moviments: [],
    };

    let socket = new MatchSocket(window.CONFIG);
    socket.onFeedMatch((resp) => this.onFeedMatch(resp));
    socket.onFeedMoviments((resp) => this.onFeedMoviments(resp));
  }

  onFeedMatch(response){
    this.onFeedMoviments(response);
  }

  onFeedMoviments(response){
    this.setState({
      moviments: [
        <TicTacToeSquare moviment={response.moviments[8]} key={8} />,
        <TicTacToeSquare moviment={response.moviments[7]} key={7} />,
        <TicTacToeSquare moviment={response.moviments[6]} key={6} />,
        <TicTacToeSquare moviment={response.moviments[5]} key={5} />,
        <TicTacToeSquare moviment={response.moviments[4]} key={4} />,
        <TicTacToeSquare moviment={response.moviments[3]} key={3} />,
        <TicTacToeSquare moviment={response.moviments[2]} key={2} />,
        <TicTacToeSquare moviment={response.moviments[1]} key={1} />,
        <TicTacToeSquare moviment={response.moviments[0]} key={0} />
      ]
    })
  }

  render() {
    return (
      <div className="tic-tac-toes board">
        {
          this.state.moviments.map((square) => {
            return square;
          })
        }
      </div>
    );
  }
}

export default TicTacToeBoard;
