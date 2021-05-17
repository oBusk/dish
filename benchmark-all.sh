#!/bin/bash

# Run all benchs on resolves in resolvers.txt

cat resolvers.txt private-resolvers.txt | source benchmark-multiple.sh
