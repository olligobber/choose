# Choose

A simple terminal tool to choose a random item from a list.

## Building

Use `make` to build. Requires haskell stack.

## Usage

The built executable is placed at `exe/choose`. Run this (or use `stack exec`) with no arguments to pick a random line from standard input, or with a file name as an argument to pick a random line from that file. Use the `-c` flag to choose a random character instead of a random line. Trailing empty lines are ignored, and if `-c` is enabled, then trailing newlines are ignored.