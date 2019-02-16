import React from 'react';
import MatchSocket from '../services/MatchSocket';
import MatchInfoCardRound from './MatchInfoCardRound.jsx';
const moment = require('moment');

class MatchInfoCard extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      moviments: [],
      firstPlayer: {},
      secondPlayer: {},
      matchStatus: null,
      finishedAt: null,
      winner: {
        name: "-"
      }
    };

    let socket = new MatchSocket(window.CONFIG);
    socket.onFeedMatch((resp) => this.onFeedMatch(resp));
    socket.onFeedMoviments((resp) => this.onFeedMoviments(resp));
  }

  onFeedMatch(response){
    this.onFeedMoviments(response);
    this.setState({
      firstPlayer: response.match.first_player,
      secondPlayer: response.match.second_player,
      matchStatus: response.match.status,
      finishedAt: response.match.finished_at,
      winner: response.match.winner
    })
  }

  onFeedMoviments(response){
    let moviments = this._chunkBy(response.moviments, 2);

    this.setState({
      moviments: moviments.map((round, i) => <MatchInfoCardRound round={round} key={i} />)
    })
  }

  render() {
    return (
      <nav className="panel match-info-card">
        <p className="panel-block is-active">
          <span className="panel-icon">
            <i className="fas fa-user" aria-hidden="true"></i>
          </span>
          {this.state.firstPlayer.name} ({this.state.firstPlayer.rating})<br />
        </p>
        <div className="panel-block">
          <ol className="moviment-list">
            {
              this.state.moviments.map((round) => {
                return round;
              })
            }
          </ol>
        </div>
        <p className="panel-block is-active">
          <span className="panel-icon">
            <i className="fas fa-user" aria-hidden="true"></i>
          </span>
          {this.state.secondPlayer.name} ({this.state.secondPlayer.rating})<br />
        </p>
        <p className="panel-block is-capitalized has-text-weight-light">
          Status: {this.state.matchStatus}<br />
          Last Update: {this._formatDate(this.state.finishedAt)}<br />
          Winner: {this._fetchWinner(this.state)}<br />
        </p>
      </nav>
    );
  }

  _chunkBy(list, chunk) {
    let i, j, round, newList = [];
    for (i=0, j=list.length; i<j; i+=chunk) {
        round = list.slice(i, i + chunk);
        newList.push(round);
    }
    return newList;
  }

  _formatDate(date) {
    if(date) {
      return moment(date).format('lll');
    } else {
      return "-";
    }
  }

  _fetchWinner(state) {
    if(state.matchStatus === "ongoing") {
      return "-";
    } else if(state.matchStatus === "draw") {
      return "draw";
    } else {
      return state.winner.name;
    }
  }
}

export default MatchInfoCard;
