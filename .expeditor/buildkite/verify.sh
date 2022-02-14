#!/bin/bash

set -ueo pipefail

echo "--- system details"
uname -a
ruby -v
bundle --version

echo "--- bundle install"
bundle config set --local without tools maintenance deploy
bundle install --jobs=7 --retry=3

echo "+++ bundle exec rake lint"
bundle exec rake lint

echo "+++ bundle exec rake test:unit"
bundle exec rake test:unit
RAKE_EXIT=$?

# If coverage is enabled, then we need to pick up the coverage/coverage.json file
if [ -n "$CI_ENABLE_COVERAGE" ]; then
  echo "--- installing sonarscanner"
  export SONAR_SCANNER_VERSION=4.6.2.2472
  export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION-linux
  curl --create-dirs -sSLo $HOME/.sonar/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip
  unzip -o $HOME/.sonar/sonar-scanner.zip -d $HOME/.sonar/
  export PATH=$SONAR_SCANNER_HOME/bin:$PATH
  export SONAR_SCANNER_OPTS="-server"

  echo "--- running sonarscanner"
  sonar-scanner \
  -Dsonar.organization=inspec \
  -Dsonar.projectKey=inspec_inspec-azure \
  -Dsonar.sources=. \
  -Dsonar.host.url=https://sonarcloud.io
fi

exit $RAKE_EXIT
