#!/bin/bash
pushd .
rm -rf ~/git/CMakeTest/build
mkdir ~/git/CMakeTest/build
cd ~/git/CMakeTest/build
#for i in {1..500}
#do
#	cmake -P main.cmake > /dev/null 2> /dev/null
#done
cmake ..
ret=$?

popd
exit $ret
