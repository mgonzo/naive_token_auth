var Info = React.createClass({

  componentDidMount: function () {
  },

  getInitialState: function () {
    return {
      user: '',
      token: '',
      expires: '',
    };
  },

  render: function() {
    var that = this;

    return (
      <span>
        <label>Current User:</label><span>{this.state.user}</span>
        <label>Current Token:</label><span>{this.state.token}</span>
        <label>Expires:</label><span>{this.state.expires}</span>
      </span>
    );
  }
});

ReactDOM.render(
    <Info />, 
    document.getElementById('info')
);
