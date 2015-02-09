#!/bin/sh

oneTimeSetUp() {
    git config core.autocrlf false
    git config core.safecrlf false
    git config core.eol false
}

clean() {
    git reset --hard &> /dev/null
    git clean -f &> /dev/null
    git checkout master &> /dev/null
    git branch -D test &> /dev/null
    git push origin :test &> /dev/null
    rm -rf "${0%/*}/../tmprepo"
}

setUp() {
    clean
    git checkout -b test &> /dev/null
    rm "${0%/*}/../.gitattributes"
    cp tests/resources/crlf.txtcr ./crlf.txt
    cp tests/resources/lf.txt ./
    cp tests/resources/cr.txt ./
}

tearDown() {
    clean
}

# load shunit2
. "${0%/*}/../vendors/shunit2/src/shunit2"