#!/bin/bash

# inputs: Flutter in PATH
# outputs: coverage in coverage/lcov.info

set -o errexit # exit script when command fails
set -o nounset # exit script when it tries to use undeclared variables
set -o xtrace # traces commands before executing them

flutter format --set-exit-if-changed .
flutter pub get
flutter analyze --no-congratulate --no-pub
flutter test --coverage --coverage-path coverage/lcov.info
