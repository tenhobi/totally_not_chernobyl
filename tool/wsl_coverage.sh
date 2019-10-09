#!/usr/bin/env bash

cmd.exe /c flutter test --coverage
sed -i 's/\\/\//g' coverage/lcov.info
genhtml coverage/lcov.info --output-directory out
