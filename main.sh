#!/bin/bash
pushd . > /dev/null

mkdir -p build
cd build
#for i in {1..500}
#do
#        echo $i
#        cmake .. 2> /dev/null > /dev/null
#done

cmake ..
ret=$?

popd > /dev/null
exit $ret
