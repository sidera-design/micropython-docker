# Create build image
FROM python:3.11-slim as build-mpython

ENV BUILD_VERBOSE 1
COPY ./ /usr/local/src/micropython-docker
WORKDIR /usr/local/src/micropython-docker
RUN <<EOS
echo "### install build tools"
apt-get update
apt-get install -y git
apt-get install -y make
apt-get install -y build-essential
apt-get install -y libreadline-dev
apt-get install -y libffi-dev
apt-get install -y pkg-config
echo "### install micropython repository"
git update --init micropython/
cd micropython
echo "### build for unix port standard"
source tools/ci.sh && ci_unix_standard_build
echo "### run main test suite"
source tools/ci.sh && ci_unix_standard_run_tests
tests/run-tests.py --print-failures
echo "### install"
cd ports/unix
make install
EOS

CMD /usr/local/bin/micropython