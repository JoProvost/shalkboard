.PHONY: all test

all: test bin/shalkboard

bin/shalkboard: compile.sh *.sh lib/*.sh lib/font/*.sh
	@ ./compile.sh shalkboard.sh

test:
	@ find . -name *_test.sh -print0 | xargs -n 1 -0 bash
