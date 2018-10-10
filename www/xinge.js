var exec = require('cordova/exec');

module.exports = {
  registerDevice: function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, 'xinge', 'registerDevice', []);
  },
  bindAccount: function (account, successCallback, errorCallback) {
    exec(successCallback, errorCallback, 'xinge', 'bindAccount', [account]);
  },
  unbindAccount: function (account, successCallback, errorCallback) {
    exec(successCallback, errorCallback, 'xinge', 'unbindAccount', [account]);
  }
}
