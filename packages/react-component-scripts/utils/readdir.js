var readdir = require('fs-readdir-recursive');
var util = require('babel-core').util;

function readdirFilter(filename) {
  return readdir(filename).filter(function(filename) {
    return util.canCompile(filename);
  });
}

module.exports = {
  readdir,
  readdirFilter,
};
