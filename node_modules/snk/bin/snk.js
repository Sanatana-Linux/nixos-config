#!/usr/bin/env node
var preview = require('../');
var version = require('../package.json').version;
var commander = require('commander');
var open = require('open');
var fs = require('fs');
var path = require('path');

commander
  .version(version)
  .usage('[options] <file>')
  .option('-n, --nopen', 'don\'t open the file in the browser')
  .option('-p, --profile [profile]', 'use a profile (gh|npm) [gh]')
  .parse(process.argv);

var args = commander.args;

if(args.length == 1) {
  var file = path.resolve(args[0]);
  var stat = fs.statSync(file);
  if(stat.isFile()) {
    preview(file, commander.profile).then(function (port) {
      if(!commander.nopen) {
        open('http://localhost:' + port + '/')
      }
    });
  } else {
    commander.help();
  }
} else {
  commander.help();
}
