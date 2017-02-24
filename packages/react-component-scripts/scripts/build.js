var babel = require('babel-core');
var chalk = require('chalk');
var fs = require('fs');
var micromatch = require('micromatch');
var path = require('path');
var outputFileSync = require('output-file-sync');
var slash = require('slash');
var paths = require('../config/paths');
var readdir = require('../utils/readdir').readdir;

var DEFAULT_COMPILABLE_EXTENSIONS = ['.es6', '.js', '.es', '.jsx'];
var SRC_IGNORE_PATTERNS = [
  // Default Jest testMatch patterns
  '**/__tests__/**/*.js?(x)',
  '**/?(*.)(spec|test).js?(x)',

  // Storybook patterns
  '**/?(.*).storybook.js?(x)',
];
var SRC_DIR = paths.libSrc;
var BUILD_DIR = paths.libBuild;
var ENABLE_SOURCE_MAPS = true; // TODO make this optional?

console.log();
console.log(chalk.cyan('> Creating ES5-compatible build...'));
console.log(chalk.cyan('> Building with Babel...'));

readdir(SRC_DIR).forEach(function(filename) {
  var src = path.join(SRC_DIR, filename);
  _handleFile(src, filename);
});

console.log();
console.log(chalk.green('Compiled successfully.'));
console.log();

function _handleFile(src, filename) {
  const ignoreRegexes = SRC_IGNORE_PATTERNS.map(function(patt) {
    return micromatch.makeRe(patt);
  });
  if (babel.util.shouldIgnore(src, ignoreRegexes)) {
    return;
  }
  if (babel.util.canCompile(filename, DEFAULT_COMPILABLE_EXTENSIONS)) {
    _write(src, filename);
  } else {
    var dest = path.join(BUILD_DIR, filename);
    outputFileSync(dest, fs.readFileSync(src));
    _chmod(src, dest);
  }
}

function _write(src, relative) {
  // remove extension and then append back on .js
  relative = relative.replace(/\.(\w*?)$/, '') + '.js';

  const dest = path.join(BUILD_DIR, relative);

  const data = _compile(src, {
    sourceFileName: slash(path.relative(dest + '/..', src)),
    sourceMapTarget: path.basename(relative),
    babelrc: false,
    presets: [require.resolve('babel-preset-react-app')],
  });
  if (data.ignored) return;

  // we've requested explicit sourcemaps to be written to disk
  if (data.map && ENABLE_SOURCE_MAPS) {
    const mapLoc = dest + '.map';
    data.code = _addSourceMappingUrl(data.code, mapLoc);
    outputFileSync(mapLoc, JSON.stringify(data.map));
  }

  outputFileSync(dest, data.code);
  _chmod(src, dest);

  console.log(`  ${src} -> ${dest}`);
}

function _compile(filename, opts) {
  try {
    const code = fs.readFileSync(filename, 'utf8');
    return _transform(filename, code, opts);
  } catch (err) {
    throw err;
  }
}

function _transform(filename, code, opts) {
  opts.filename = filename;

  const result = babel.transform(code, opts);
  result.filename = filename;
  result.actual = code;
  return result;
}

function _chmod(src, dest) {
  fs.chmodSync(dest, fs.statSync(src).mode);
}

function _addSourceMappingUrl(code, loc) {
  return code + '\n//# sourceMappingURL=' + path.basename(loc);
}
