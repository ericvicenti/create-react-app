#!/bin/bash
# Copyright (c) 2015-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.

# ******************************************************************************
# This is an end-to-end test intended to run on CI.
# You can also run it locally but it's slow.
# ******************************************************************************

# Start in tasks/ even if run from root directory
cd "$(dirname "$0")"

# CLI and app temporary locations
# http://unix.stackexchange.com/a/84980
temp_cli_path=`mktemp -d 2>/dev/null || mktemp -d -t 'temp_cli_path'`
temp_component_path=`mktemp -d 2>/dev/null || mktemp -d -t 'temp_component_path'`

function cleanup {
  echo 'Cleaning up.'
  cd $root_path
  # Uncomment when snapshot testing is enabled by default:
  # rm ./packages/react-scripts/template/src/__snapshots__/App.test.js.snap
  rm -rf $temp_cli_path $temp_component_path
}

# Error messages are redirected to stderr
function handle_error {
  echo "$(basename $0): ERROR! An error was encountered executing line $1." 1>&2;
  cleanup
  echo 'Exiting with error.' 1>&2;
  exit 1
}

function handle_exit {
  cleanup
  echo 'Exiting without error.' 1>&2;
  exit
}

function create_react_component {
  node "$temp_cli_path"/node_modules/create-react-component/index.js $*
}

# Check for the existence of one or more files.
function exists {
  for f in $*; do
    test -e "$f"
  done
}

# Exit the script with a helpful error message when any error is encountered
trap 'set +x; handle_error $LINENO $BASH_COMMAND' ERR

# Cleanup before exit on any termination signal
trap 'set +x; handle_exit' SIGQUIT SIGTERM SIGINT SIGKILL SIGHUP

# Echo every command being executed
set -x

# Go to root
cd ..
root_path=$PWD

# If the node version is < 4, the script should just give an error.
if [[ `node --version | sed -e 's/^v//' -e 's/\..*//g'` -lt 4 ]]
then
  cd $temp_component_path
  err_output=`node "$root_path"/packages/create-react-app/index.js test-node-version 2>&1 > /dev/null || echo ''`
  [[ $err_output =~ You\ are\ running\ Node ]] && exit 0 || exit 1
fi

npm install

if [ "$USE_YARN" = "yes" ]
then
  # Install Yarn so that the test can use it to install packages.
  npm install -g yarn
  yarn cache clean
fi

# Lint own code
./node_modules/.bin/eslint --ignore-path .gitignore ./

# ******************************************************************************
# Next, pack react-component-scripts and create-react-component so we can verify they work.
# ******************************************************************************

# Pack CLI
cd $root_path/packages/create-react-component
cli_path=$PWD/`npm pack`

# Go to react-component-scripts
cd $root_path/packages/react-component-scripts

# Save package.json because we're going to touch it
cp package.json package.json.orig

# Replace own dependencies (those in the `packages` dir) with the local paths
# of those packages.
node $root_path/tasks/replace-own-deps.js 'react-component-scripts/package.json'

# Finally, pack react-scripts
scripts_path=$root_path/packages/react-component-scripts/`npm pack`

# Restore package.json
rm package.json
mv package.json.orig package.json

# ******************************************************************************
# Now that we have packed them, create a clean app folder and install them.
# ******************************************************************************

# Install the CLI in a temporary location
cd $temp_cli_path
npm install $cli_path

# Run create-react-component in a temporary location
cd $temp_component_path
create_react_component --scripts-version=$scripts_path test-component

# ******************************************************************************
# Now that we used create-react-app to create an app depending on react-scripts,
# let's make sure all npm scripts are in the working state.
# ******************************************************************************

# Enter the app directory
cd test-component

# Test the build
npm run build

# Check for expected output
exists package.json


# Cleanup
cleanup
