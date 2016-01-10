var Info = React.createClass({

  componentDidMount: function () {
    document.addEventListener("setUser", this.eventHandler, false);
    var user = sessionStorage.getItem('user');
    var token = sessionStorage.getItem('token');
    this.setState({
      user: user,
      token: token,
    });
  },

  getInitialState: function () {
    return {
      user: '',
      token: '',
      expires: '',
    };
  },

  eventHandler: function (e) {
    this.setState({
      user: e.detail.user,
      token: e.detail.token,
      expires: e.detail.expires,
    });
  },

  style: {
    userLabel: {
      color: 'red',
      marginRight: '5px',
    },
    user: {},
    tokenLabel: {
      color: 'red',
      display: 'block',
      marginTop: '15px',
      marginBottom: '5px',
    },
    token: {
      display: 'block',
      width: '100%',
      boxSizing: 'border-box',
      wordBreak: 'break-all',
      marginBottom: '15px'
    },
    expiresLabel: {
      color: 'red',
      marginRight: '5px',
    },
  },


  render: function() {
    var that = this;

    return (
      <span>
        <label style={this.style.userLabel}>Current User:</label><span>{this.state.user}</span>
        <label style={this.style.tokenLabel}>Current Token:</label><span style={this.style.token}>{this.state.token}</span>
        <label style={this.style.expiresLabel}>Expires:</label><span>{this.state.expires}</span>
      </span>
    );
  }
});

ReactDOM.render(
    <Info />, 
    document.getElementById('info')
);
