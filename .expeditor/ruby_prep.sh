#!/bin/bash

set +x
echo
gem env
echo
gem install bundler --no-ri --no-rdoc
echo
bundle -v
echo
chef -v
