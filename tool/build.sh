#!/bin/bash

# inputs: Flutter in PATH
# outputs: build for $1 in build/

set -o errexit # exit script when command fails
set -o nounset # exit script when it tries to use undeclared variables
set -o xtrace # traces commands before executing them

flutter pub run build_runner build
flutter build --$1
