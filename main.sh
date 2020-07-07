#!/bin/bash
pushd . > /dev/null
#rm -rf ~/git/CMakeTest/build
#mkdir ~/git/CMakeTest/build
cd ~/git/CMakeTest/build
#for i in {1..500}
#do
#        echo $i
#        cmake .. 2> /dev/null > /dev/null
#done
cmake ..
ret=$?

popd > /dev/null
exit $ret
