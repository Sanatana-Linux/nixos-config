var hogan = require('hogan.js');
var fs = require('fs');
var path = require('path');

var template = fs.readFileSync(path.join(__dirname, 'template.html'), {
  encoding: 'utf8'
});

var compiled = module.exports = hogan.compile(template);