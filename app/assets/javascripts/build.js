'use strict';

var Info = React.createClass({
  displayName: 'Info',

  componentDidMount: function componentDidMount() {
    document.addEventListener("setUser", this.eventHandler, false);
    var user = sessionStorage.getItem('user');
    var token = sessionStorage.getItem('token');
    this.setState({
      user: user,
      token: token
    });
  },

  getInitialState: function getInitialState() {
    return {
      user: '',
      token: '',
      expires: ''
    };
  },

  eventHandler: function eventHandler(e) {
    this.setState({
      user: e.detail.user,
      token: e.detail.token,
      expires: e.detail.expires
    });
  },

  style: {
    userLabel: {
      color: 'red',
      marginRight: '5px'
    },
    user: {},
    tokenLabel: {
      color: 'red',
      display: 'block',
      marginTop: '15px',
      marginBottom: '5px'
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
      marginRight: '5px'
    }
  },

  render: function render() {
    var that = this;

    return React.createElement(
      'span',
      null,
      React.createElement(
        'label',
        { style: this.style.userLabel },
        'Current User:'
      ),
      React.createElement(
        'span',
        null,
        this.state.user
      ),
      React.createElement(
        'label',
        { style: this.style.tokenLabel },
        'Current Token:'
      ),
      React.createElement(
        'span',
        { style: this.style.token },
        this.state.token
      ),
      React.createElement(
        'label',
        { style: this.style.expiresLabel },
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
'use strict';

var Shelly = React.createClass({
  displayName: 'Shelly',

  getInitialState: function getInitialState() {
    return {
      history: ''
    };
  },

  componentDidMount: function componentDidMount() {
    ReactDOM.findDOMNode(this).lastElementChild.focus();
    this.commands = this.getCommands();
    this.keys = Object.keys(this.commands);
    document.addEventListener("messageIn", this.messageHandler, false);
  },

  componentWillUnmount: function componentWillUnmount() {},

  messageHandler: function messageHandler(e, args) {
    this.print(e.detail.message);
  },

  focus: function focus(e) {
    ReactDOM.findDOMNode(this).lastElementChild.focus();
  },

  keyup: function keyup(e) {
    var that = this;

    if (e.key === 'Enter' || e.keyCode === 13) {
      console.log('<CR>');

      var arr = e.target.value.trim().split(' ');
      var cmd = arr.shift();

      this.keys.map(function (key, index) {
        if (cmd === key) {
          that.commands[key].call(that, arr);
        }
      });

      e.target.value = '';
    }
  },

  print: function print(text) {
    if (this.state.history.length) {
      text = '\n' + text;
    }

    this.setState({
      'history': this.state.history.concat(text)
    });
  },

  printf: function printf(text, args) {
    // how many args
    // find %1 and replace it with first arg
    // find %2 and replace it with second arg
    // etc...
    //
  },

  commands: null,

  getCommands: function getCommands() {
    var commands = {
      echo: function echo(arr) {
        this.print(arr.join(' '));
      },

      clear: function clear(arr) {
        this.setState({
          'history': ''
        });
      },

      date: function date(arr) {
        this.print(Date.now());
      }
    };

    var keys = Object.keys(this.props.commands),
        that = this;

    keys.map(function (key) {
      if (that.props.commands.hasOwnProperty(key)) {
        commands[key] = that.props.commands[key];
      }
    });

    return commands;
  },

  style: {
    container: {
      backgroundColor: '#000',
      boxSizing: 'border-box',
      color: '#FFF',
      height: '100%',
      width: '100%'
    },

    textarea: {
      backgroundColor: '#000',
      border: 'none',
      boxSizing: 'inherit',
      color: '#FFF',
      height: '1em',
      resize: 'none',
      width: '100%'
    },

    stdout: {
      padding: '0',
      margin: '0'
    }

  },

  render: function render() {
    var that = this;

    return React.createElement(
      'div',
      { className: 'shelly-container', style: this.style.container, onClick: this.focus },
      React.createElement(
        'pre',
        { style: this.style.stdout },
        this.state.history
      ),
      React.createElement('textarea', { style: this.style.textarea, onKeyUp: this.keyup })
    );
  }
});