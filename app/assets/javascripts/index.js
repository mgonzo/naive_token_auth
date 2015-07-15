$(function () {
  console.log('here\'s some js!');
  var self = this;

  // click create
  // create success
  
  $('#create-user-action').bind('click', function (e) {
    console.log('create was clicked');
    self.api.postCreateUser();
  });

  $('#signin-user-action').bind('click', function (e) {
    console.log('signin was clicked');
    self.api.postSigninUser();
  });

  self.api = {
    postCreateUser: function () {
      console.log('post create ...');
      var user = {
        'name': $('#auth .create-user .name').val(),
        'email': $('#auth .create-user .email').val(),
        'password1': $('#auth .create-user #password1').val(),
        'password2': $('#auth .create-user #password2').val()
      };

      $.ajax({
        url: '/api/v1/user',
        type: 'POST',
        data: user
      })
        .done(self.api.createUserSuccess)
        .fail(self.api.createUserFail);
    },
    postSigninUser: function () {
      console.log('post signin ...');
      var user = {
        'name': $('#auth .signin-user .name').val(),
        'password': $('#auth .signin-user .password').val()
      };

      $.ajax({
        url: '/api/v1/user/signin',
        type: 'POST',
        data: user
      })
        .done(self.api.signinUserSuccess)
        .fail(self.api.signinUserFail);
    },
    createUserSuccess: function (data, status, jqxhr) {
      console.log('create success ...');
      self.token.store(data.token);
    },
    createUserFail: function (jqxhr, status, err) {
      console.log('create fail ...');
    },
    signinUserSuccess: function () {
      console.log('signin success ...');
      self.token.store(data.token);
    },
    signinUserFail: function () {
      console.log('signin fail ...');
    }
  };


  self.token = {
    store: function (token) {
      sessionStorage.setItem('token', token)
      console.log('stored token');
      // set token in localstorage
      // make sure it replaces any old token
    },
    get: function () {
      // return the stored token
    },
    isValid: function () {
      // return false if the current token
      // is expired or if there is no token stored
    }
  };

});
