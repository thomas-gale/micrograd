.PHONY: install run test

install:
	pipx install poetry
	poetry install --no-root
	curl -s https://get.modular.com | sh -
	modular install mojo

run: 
	poetry run mojo run src/main.mojo

test: 
	poetry run mojo test -I src test

package:
	mkdir -p bin
	poetry run mojo package src/micrograd -o bin/micrograd.mojopkg

build:
	mkdir -p bin
	poetry run mojo build src/main.mojo -o bin/micrograd

run-build:
	bin/micrograd

build-test:
	mkdir -p bin
	poetry run mojo build src/tests.mojo -o bin/microgradtest

run-build-test:
	bin/microgradtest
