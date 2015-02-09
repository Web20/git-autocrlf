#!/bin/sh

testNothing() {
    assertEquals "This file has CRLF end lines" 1 `file crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file cr.txt | grep -c " CR "`
    assertEquals "This file has LF end lines" 0 `file lf.txt | grep -c "terminators"`

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CRLF end lines" 1 `file tmprepo/crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file has LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
}

testGitAttributes() {
    cp "${0%/*}/../gitattributes" "${0%/*}/../.gitattributes"

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file does not have CRLF end lines" 0 `file tmprepo/crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file has LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
}

testGitConfigInput() {
    echo "git config --global core.autocrlf input\n" > "${0%/*}/../.gitconfig" # it does not work

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CRLF end lines" 1 `file tmprepo/crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file has LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
}

testGitConfigTrue() {
    echo "git config --global core.autocrlf true\n" > "${0%/*}/../.gitconfig" # it does not work

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CRLF end lines" 1 `file tmprepo/crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file has LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
}

. "${0%/*}/base.sh"