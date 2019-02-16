import SocketConnection from '../SocketConnection';

class MatchSocket {
  constructor(config){
    this.config = config;
    let connection = new SocketConnection();
    this.channel = connection.join("match:" + this.config.match_type + ":" + this.config.match_id);
  }

  onFeedMoviments(callback){
    this.channel.on(`feed_moviments`, response => {
      callback(response);
    })
  }

  onFeedMatch(callback){
    this.channel.on(`feed_match`, response => {
      callback(response);
    })
  }
}

export default MatchSocket;
