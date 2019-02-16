import React from 'react';
import ReactDOM from 'react-dom';

import MatchInfoCard from './components/MatchInfoCard.jsx';
import TicTacToeBoard from './components/TicTacToeBoard.jsx';

if(document.getElementById('match-info-card')) {
  ReactDOM.render(<MatchInfoCard />, document.getElementById('match-info-card'));
}
if(document.getElementById('tic-tac-toe-board')) {
  ReactDOM.render(<TicTacToeBoard />, document.getElementById('tic-tac-toe-board'));
}
