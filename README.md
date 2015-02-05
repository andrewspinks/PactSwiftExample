# Example Pact Swift project using Carthage
[![Build Status](https://travis-ci.org/andrewspinks/PactSwiftExample.svg?branch=master)](https://travis-ci.org/andrewspinks/PactSwiftExample)

See the Pact Swift library for more details. [https://github.com/DiUS/pact-consumer-swift]

## Installation with Carthage

### Install the [pact-mock_service][pact-mock-service]
  `gem install pact-mock_service -v 0.2.4`

### Add the PactConsumerSwift library to your project
- Add `github "DiUS/pact-consumer-swift` to your Cartfile
- Follow the Carthage guidelines for building dependencies. [https://github.com/Carthage/Carthage]
- Add the PactConsumerSwift.framework to your test target
- For iOS projects, you must add a run script to copy the framework to the correct location. See the Carthage documentation for more info.
- See [https://github.com/andrewspinks/PactSwiftExample] for an example using Carthage

#### Setup your Test Target to run the pact server before the tests are run
  Modify the Test Target's scheme to add scripts to start and stop the pact server when tests are run.
  * From the menu `Product` -> `Scheme` -> `Edit Scheme`
    - Edit your test Scheme
  * Under Test, Pre-actions add a Run Script Action
    ```bash
    PATH=/path/to/pact-mock-service/binary:$PATH
    "$SRCROOT"/Carthage/Checkouts/pact-consumer-swift/scripts/start_server.sh
    ```
    - Make sure you select your project under `Provide the build settings from`, otherwise SRCROOT will not be set which the scripts depend on

  ![](http://i.imgur.com/o4tXzGK.png)
  * Under Test, Post-actions add a Run Script Action
    ```bash
    PATH=/path/to/pact-mock-service/binary:$PATH
    "$SRCROOT"/Carthage/Checkouts/pact-consumer-swift/scripts/stop_server.sh
    ```
    - Make sure you select your project under `Provide the build settings from`, otherwise SRCROOT will not be set which the scripts depend on
  ![](http://i.imgur.com/QjsEeF9.png)
