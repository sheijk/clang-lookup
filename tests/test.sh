#!/usr/bin/env sh

LOOKUP=../Release/clang_lookup.sh

function set_file() {
    FILE=$1
}

function t() {
    SYM_LINE=$1
    SYM_COL=$2
    DEF_FILE=$3
    DEF_LINE=$4

    ( ${LOOKUP} ${FILE} ${SYM_LINE} ${SYM_COL} 2> /dev/null ) | grep -q "location=${DEF_FILE}:${DEF_LINE}"
    if [ $? != 0 ] ; then
        echo "error: Expected symbol at ${FILE}:${SYM_LINE}:${SYM_COL} to be defined at ${DEF_FILE}:${DEF_LINE}"
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

