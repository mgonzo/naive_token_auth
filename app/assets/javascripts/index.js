$(function () {
  var self = this;

  // click create
  // create success

  function print(text) {
    document.body.dispatchEvent(
      new CustomEvent('messageIn', {
         detail: { message: text},
         bubbles: true,
         cancelable: true
    }));
  }


  $('#create-user-action').bind('click', function (e) {
    print('create was clicked');
    self.api.postCreateUser();
  });

  $('#signin-user-action').bind('click', function (e) {
    print('signin was clicked');
    self.api.postSigninUser();
  });

  $('#gettest').bind('click', function (e) {
    print('get test was clicked');
    self.api.getTest();
  });

  self.api = {
    postCreateUser: function () {
      print('post create ...');
      var user = {
        'name': $('.create-user .name').val(),
        'email': $('.create-user .email').val(),
        'password1': $('.create-user #password1').val(),
        'password2': $('.create-user #password2').val()
      };

      $.ajax({
        url: '/api/v1/user',
        type: 'POST',
        data: user
      })
        .done(self.api.createUserSuccess)
        .fail(self.api.createUserFail);
    },
    createUserSuccess: function (data, status, jqxhr) {
      print('create success ...');
      self.token.store(data.token);
      sessionStorage.setItem('user', data.user)
      document.body.dispatchEvent(
        new CustomEvent('setUser', {
           detail: { 
             user: data.user, 
             token: data.token, 
             expires: data.expires
           },
           bubbles: true,
           cancelable: true
      }));
    },

    createUserFail: function (jqxhr, status, err) {
      print('create fail ...');
    },

    postSigninUser: function () {
      print('post signin ...');
      var user = {
        'name': $('.signin-user .name').val(),
        'password': $('.signin-user .password').val()
      };

      $.ajax({
        url: '/api/v1/user/signin',
        type: 'POST',
        data: user
      })
        .done(self.api.signinUserSuccess)
        .fail(self.api.signinUserFail);
    },
    signinUserSuccess: function (data) {
      print('signin success ...');
      self.token.store(data.token);
    },
    signinUserFail: function () {
      print('signin fail ...');
    },

    getTest: function () {
      print('get test ...');
      $.ajax({
        beforeSend: function (jqxhr) {
          jqxhr.setRequestHeader('Authorization', self.token.get());
        },
        url: '/api/v1/test',
        type: 'GET'
      })
        .done(self.api.getTestSuccess)
        .fail(self.api.getTestFail);
    },
    getTestSuccess: function (data) {
      print('get test success ...');
      self.token.store(data.token);
    },
    getTestFail: function () {
      print('get test fail ...');
    }
  };


  self.token = {
    store: function (token) {
      sessionStorage.setItem('token', token)
      print('stored token: ' + token);
      // set token in localstorage
      // make sure it replaces any old token
    },
    get: function () {
      // return the stored token
      return sessionStorage.getItem('token');
    },
    isValid: function () {
      // return false if the current token
      // is expired or if there is no token stored
    }
  };

});
