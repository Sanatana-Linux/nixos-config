var express = require('express');
var fs = require('fs');
var tinylr = require('tiny-lr');
var path = require('path');
var chokidar = require('chokidar');
var Promise = require('bluebird');

var findport = require('./lib/findport');
var profiles = require('./lib/profiles');
var template = require('./lib/template');

var livereload_file = tinylr().options.livereload;

var app = express();

app.use(express.static(path.join(__dirname, './lib/static')));

module.exports = function (file, profileName) {

  if(!profileName) profileName = 'gh';
  var profile = profiles[profileName];

  var file_name = path.basename(file);

  var transform = profile.transform || function (md) { return md; };
  var serve = profile.serve || [];
  var styles = profile.styles || [];
  var scripts = profile.scripts || [];

  return Promise.all([
    findport(3000),
    findport(35729)
  ]).then(function (ports) {

    var app_port = ports[0];
    var lr_port = ports[1];

    var url = function (path) {
      return {
        source: 'http://localhost:' + app_port + '/' + path
      };
    };

    scripts = scripts.map(url);
    scripts.push({
      source: 'http://localhost:' + lr_port + '/livereload.js'
    });
    styles = styles.map(url);
    styles.push({
      source: 'http://localhost:' + app_port + '/normalize.css'
    });

    serve.forEach(function (path) {
      app.use(express.static(path));
    });

    var lr = tinylr();

    var compiled = '';

    var compile = function (cb) {
      if(!cb) cb = function () {};
      fs.readFile(file, {
        encoding: 'utf8'
      }, function (err, file) {
        if(file) {
          compiled = transform(file);
        }
        cb();
      });
    };

    compile();

    app.get('/', function (req, res) {
      res.send(template.render({
        title: path.basename(file),
        styles: styles,
        output: compiled,
        scripts: scripts
      }))
    });

    var watcher = chokidar.watch(file);
    watcher.on('change', function (filepath, stats) {
      compile(function () {
        lr.changed({
          body: {
            files: [filepath]
          }
        });
      });
    });

    app.listen(app_port, function () {
      console.log('server listening on port ' + app_port);
    });

    lr.listen(lr_port, function () {
      console.log('lr listening on port ' + lr_port);
    });

    return app_port;

  });

};
