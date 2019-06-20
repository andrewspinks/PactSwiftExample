#!/bin/bash
set -o pipefail

brew tap pact-foundation/pact-ruby-standalone
brew install pact-ruby-standalone
brew cask install fastlane

carthage update --platform iOS
