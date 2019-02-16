import React from 'react';

class TicTacToeSquare extends React.Component {
  render() {
    if(this.props.moviment) {
      const mark = this._fetchMark(this.props.moviment.turn);
      return this._buildMarkedSquare(mark);
    } else {
      return this._buildEmptySquare();
    }
  }

  _fetchMark(turn) {
    if(turn % 2 == 0) {
      return "o"
    } else {
      return "x"
    }
  }

  _buildEmptySquare() {
    return (
      <div className="square">
      </div>
    )
  }

  _buildMarkedSquare(mark) {
    return (
      <div className={"square " + mark}>
        { mark }
      </div>
    )
  }
}

export default TicTacToeSquare;
