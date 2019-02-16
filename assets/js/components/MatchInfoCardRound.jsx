import React from 'react';

class MatchInfoCardRound extends React.Component {
  fetchFirstPosition(round) {
    return round[0].position;
  }

  fetchSecondPosition(round) {
    if(round[1]) {
      return round[1].position;
    } else {
      return null;
    }
  }

  render() {
    return(
      <li>{this.fetchFirstPosition(this.props.round)}  {this.fetchSecondPosition(this.props.round)}</li>
    )
  }
}

export default MatchInfoCardRound;
