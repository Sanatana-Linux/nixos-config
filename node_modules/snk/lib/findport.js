var net = require('net');
var Promise = require('bluebird');

// courtesy of mikeal https://gist.github.com/mikeal/1840641
var findport = module.exports = Promise.promisify(function (port, cb) {

  var server = net.createServer();

  server.listen(port, function (err) {
    server.once('close', function () {
      cb(null, port);
    });
    server.close();
  });

  server.on('error', function (err) {
    findport(port + 1, cb);
  });

});