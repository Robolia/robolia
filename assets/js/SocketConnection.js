import {Socket} from 'phoenix';

class SocketConnection {
  constructor(){
    const instance = this.constructor.instance;
    if (instance) {
      return instance;
    }

    this.connect();
    this.constructor.instance = this;
  }

  join(name, params){
    if(!this.channel) {
      this.channel = this.socket.channel(name, params);

      this.channel.join()
        .receive("ok", resp => { console.log("Joined " + name, resp) })
        .receive("error", resp => { console.log("Unable to join " + name, resp) })
    }

    return this.channel;
  }

  connect() {
    this.socket = new Socket("ws://" + "localhost:4000" + "/socket");
    this.socket.connect();
    return this.socket;
  }
}

export default SocketConnection;
