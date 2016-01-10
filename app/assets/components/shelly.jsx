var Shelly = React.createClass({

  getInitialState: function () {
    return {
      history: '' 
    };
  },

  componentDidMount: function () {
    ReactDOM.findDOMNode(this).lastElementChild.focus();
    this.commands = this.getCommands();
    this.keys = Object.keys(this.commands);
    document.addEventListener("messageIn", this.messageHandler, false);
  },

  componentWillUnmount: function () {
  },

  messageHandler: function (e, args) {
    this.print(e.detail.message);
  },

  focus: function (e){
    ReactDOM.findDOMNode(this).lastElementChild.focus();
  },

  keyup: function (e) {
    var that = this;

    if (e.key === 'Enter' || e.keyCode === 13) {
      console.log('<CR>');

      var arr = e.target.value.trim().split(' ');
      var cmd = arr.shift();

      this.keys.map(function(key, index) {
        if(cmd === key) {
          that.commands[key].call(that, arr);
        }
      });

      e.target.value = '';
    }
  },

  print: function (text) {
    if (this.state.history.length) {
      text = '\n' + text;
    }

    this.setState({ 
      'history': this.state.history.concat(text)
    })
  },

  printf: function (text, args) {
    // how many args
    // find %1 and replace it with first arg
    // find %2 and replace it with second arg
    // etc...
    //
  },

  commands: null,

  getCommands: function () {
    var commands = {
      echo: function (arr) {
        this.print(arr.join(' '));
      },

      clear: function (arr) {
        this.setState({ 
          'history': ''
        })
      },

      date: function (arr) {
        this.print(Date.now());
      },
    };

    var keys = Object.keys(this.props.commands),
        that = this;

    keys.map(function (key) {
      if(that.props.commands.hasOwnProperty(key)) {
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
      margin: '0',
    },

  },

  render: function() {
    var that = this;

    return (
      <div className="shelly-container" style={this.style.container} onClick={this.focus}>
        <pre style={this.style.stdout}>{this.state.history}</pre>
        <textarea style={this.style.textarea} onKeyUp={this.keyup}></textarea>
      </div>
    );
  }
});
