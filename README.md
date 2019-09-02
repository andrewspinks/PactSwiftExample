# Example Pact Swift project using Carthage
[![Build Status](https://travis-ci.org/andrewspinks/PactSwiftExample.svg?branch=master)](https://travis-ci.org/andrewspinks/PactSwiftExample)

See the Pact Swift library for more details. [PactConsumerSwift library][pact-consumer-swift]

## Installation with Carthage

### Install Pact Mock Service

Install the [pact-ruby-standalone][pact-mock-service-standalone] as per installation instructions.

### Add the PactConsumerSwift library to your project
- Add `github "DiUS/pact-consumer-swift` to your Cartfile
- Follow the Carthage guidelines for building and adding a framework with Carthage: [Carthage](https://github.com/Carthage/Carthage)
- Add the `PactConsumerSwift.framework`, `Alamofire.framework` and `BrightFutures.framework` to your test target
- For iOS projects, you must add a run script to copy the frameworks to the correct location. See the Carthage documentation for more info.

#### Setup your Test Target to run the pact server before the tests are run
  Modify the Test Target's scheme to add scripts to start and stop the pact server when tests are run.
  * From the menu `Product` -> `Scheme` -> `Edit Scheme`
  * Under Test, Pre-actions add a Run Script Action
    Add a Run Script Action with the following
    _NB: the PATH variable should be set to the location of the pact-mock-service binary - you can find the path using `which pact-mock-service`_

    ```bash
    PATH=/path/to/pact-mock-service/binary:$PATH
    "$SRCROOT"/Carthage/Checkouts/pact-consumer-swift/scripts/start_server.sh
    ```
    - Make sure you select your project under `Provide the build settings from`, otherwise SRCROOT will not be set which the scripts depend on

  ![](http://i.imgur.com/o4tXzGK.png)
  * Under Test, Post-actions add a Run Script Action to stop the pact service.

    ```bash
    PATH=/path/to/pact-mock-service/binary:$PATH
    "$SRCROOT"/Carthage/Checkouts/pact-consumer-swift/scripts/stop_server.sh
    ```
    - Make sure you select your project under `Provide the build settings from`, otherwise SRCROOT will not be set which the scripts depend on
  ![](http://i.imgur.com/QjsEeF9.png)

## Writing tests
See PactSwifExampleTests.swift for examples of writing Pact tests in Swift. For Objective-C see [Pact ObjectiveC Example](https://github.com/andrewspinks/PactObjectiveCExample)

[pact-consumer-swift]: https://github.com/DiUS/pact-consumer-swift
[pact-mock-service-standalone]: https://github.com/pact-foundation/pact-ruby-standalone