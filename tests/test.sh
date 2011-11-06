#!/usr/bin/env sh

LOOKUP=../Release/clang_lookup.sh
ARGS=

function set_file() {
    FILE=$1
    ARGS=$2
}

TEST_COUNT=0
ERROR_COUNT=0

function t() {
    SYM_LINE=$1
    SYM_COL=$2
    DEF_FILE=$3
    DEF_LINE=$4

    TEST_COUNT=$(expr ${TEST_COUNT} + 1)

    RE="location=(./)?${DEF_FILE}:${DEF_LINE}"
    ( ${LOOKUP} ${FILE} ${SYM_LINE} ${SYM_COL} ${ARGS} 2> /dev/null ) | grep -qE ${RE}
    if [ $? != 0 ] ; then
        echo "error: Expected symbol at ${FILE}:${SYM_LINE}:${SYM_COL} to be defined at ${DEF_FILE}:${DEF_LINE}"
        ERROR_COUNT=$(expr ${ERROR_COUNT} + 1)
    fi
}

set_file simple.c
t 20 10 simple.c 0 non_existing_file.h | grep -q error
if [ $? != 0 ] ; then
    echo "error: self test failed. Unit test results might be unreliable"
fi

set_file simple.c
t 54 16 simple.c 6
t 54 24 simple.c 46
t 51 22 simple.c 50
t 43 27 simple.c 36
t 38 28 simple.c 36
t 34 28 simple.c 31
t 28 32 simple.c 22

set_file include.c
t 15 11 include.c 5
t 19 10 local_testlib.h 4
t 20 10 local_testlib.h 5

set_file custom_include_dir.c "-Iapi_dir"
t 16 12 custom_include_dir.c 6
t 20 8 api_dir/include/cl_test_lib.h 18

set_file simplepp.cpp
t 7 10 simplepp.cpp 2
t 8 10 simplepp.cpp 3

set_file class.cpp
t 5 24 class.cpp 14
t 20 18 class.cpp 5
t 22 10 class.cpp 2
t 33 6 class.cpp 17
t 34 8 class.cpp 9
t 35 10 class.cpp 25
t 27 22 class.cpp 11

set_file clang_api.cpp "-I../llvm/tools/clang/include"
t 8 30 ../llvm/tools/clang/include/clang-c/Index.h 191
t 9 10 ../llvm/tools/clang/include/clang-c/Index.h 200

set_file llvm_api.cpp "-I../llvm/include -DNDEBUG -D_GNU_SOURCE -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS"
t 8 8 llvm_api.cpp 6

echo "${ERROR_COUNT}/${TEST_COUNT} tests failed"

