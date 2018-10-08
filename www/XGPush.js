var exec = require('cordova/exec');

module.exports = {
  registerPush: function (account, successCallback, errorCallback) {
    exec(successCallback, errorCallback, 'XGPush', 'registerPush', [account]);
  }
}
