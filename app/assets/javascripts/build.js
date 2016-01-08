'use strict';

var Info = React.createClass({
  displayName: 'Info',

  componentDidMount: function componentDidMount() {},

  getInitialState: function getInitialState() {
    return {
      user: '',
      token: '',
      expires: ''
    };
  },

  render: function render() {
    var that = this;

    return React.createElement(
      'span',
      null,
      React.createElement(
        'label',
        null,
        'Current User:'
      ),
      React.createElement(
        'span',
        null,
        this.state.user
      ),
      React.createElement(
        'label',
        null,
        'Current Token:'
      ),
      React.createElement(
        'span',
        null,
        this.state.token
      ),
      React.createElement(
        'label',
        null,
        'Expires:'
      ),
      React.createElement(
        'span',
        null,
        this.state.expires
      )
    );
  }
});

ReactDOM.render(React.createElement(Info, null), document.getElementById('info'));