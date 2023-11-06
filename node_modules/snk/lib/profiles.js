var path = require('path');
var marked = require('marked');
var highlight = require('highlight.js');

module.exports = {

  gh: {
    serve: [
      path.join(__dirname, 'profile-gh/')
    ],
    styles: [
      'gh.css',
      'highlight.css'
    ],
    transform: function (md) {

      marked.setOptions({
        highlight: function (code, lang) {
          if(lang) {
            return highlight.highlight(lang, code, true).value;
          } else {
            return highlight.highlightAuto(code).value;
          }
        }
      });

      return marked(md);
    }
  },

  npm: {
    serve: [
      path.join(__dirname, 'profile-npm')
    ],
    styles: [
      'npm.css',
      'sh.css'
    ],
    scripts: [
      'sh_main.js',
      'sh_javascript.min.js',
      'scripts.js'
    ],
    transform: function (md) {

      return marked(md);
    }
  }

};