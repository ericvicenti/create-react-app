var fs = require('fs');
var path = require('path');

var libDirectory = fs.realpathSync(process.cwd());
function resolveLib(relativePath) {
  return path.resolve(libDirectory, relativePath);
}

module.exports = {
  libBuild: resolveLib('build'),
  libSrc: resolveLib('src'),
  libPackageJson: resolveLib('package.json'),
}
