This project was bootstrapped with [Create React App](https://github.com/facebookincubator/create-react-app).

Below you will find some information on how to perform common tasks.<br>
You can find the most recent version of this guide [here](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md).

## Table of Contents

- [Updating to New Releases](#updating-to-new-releases)
- [Sending Feedback](#sending-feedback)
- [Folder Structure](#folder-structure)
- [Available Scripts](#available-scripts)
  - [npm start](#npm-start)
  - [npm test](#npm-test)
  - [npm run build](#npm-run-build)

  ## Updating to New Releases

  Create React App is divided into two packages:

  * `create-react-component` is a global command-line utility that you use to create new projects.
  * `react-component-scripts` is a development dependency in the generated projects (including this one).

  You almost never need to update `create-react-component` itself: it delegates all the setup to `react-component-scripts`.

  When you run `create-react-component`, it always creates the project with the latest version of `react-component-scripts` so you’ll get all the new features and improvements in newly created components automatically.

  To update an existing project to a new version of `react-component-scripts`, [open the changelog](https://github.com/facebookincubator/create-react-app/blob/master/CHANGELOG.md), find the version you’re currently on (check `package.json` in this folder if you’re not sure), and apply the migration instructions for the newer versions.

  In most cases bumping the `react-scripts` version in `package.json` and running `npm install` in this folder should be enough, but it’s good to consult the [changelog](https://github.com/facebookincubator/create-react-app/blob/master/CHANGELOG.md) for potential breaking changes.

  We commit to keeping the breaking changes minimal so you can upgrade `react-component-scripts` painlessly.

  ## Sending Feedback

  We are always open to [your feedback](https://github.com/facebookincubator/create-react-app/issues).

  ## Folder Structure

  After creation, your project should look like this:

  ```
  my-component/
    README.md
    node_modules/
    package.json
    src/
      MyComponent.js
  ```

  The `src` directory is where your component's code should live.

  ## Available Scripts

  In the project directory, you can run:

  ### `npm start`

  Runs the component in the development mode.<br>
  Open [http://localhost:3300](http://localhost:3300) to view the component storybook in the browser.

  The page will reload if you make edits.

  ### `npm test`

  Launches the test runner in the interactive watch mode.

  ### `npm run build`

  Builds the component for publishing or deployment.

  ### `npm run eject`

  **Note: this is a one-way operation. Once you `eject`, you can’t go back!**

  If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

  Instead, it will copy all the configuration files and the transitive dependencies (Babel, Jest, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.
