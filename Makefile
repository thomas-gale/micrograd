.PHONY: install run test

install:
	@echo "Installing dependencies (for docker/bash)..."
	pipx install poetry
	poetry install --no-root
	curl -s https://get.modular.com | sh -
	modular install mojo

run: 
	poetry run mojo run src/main.mojo

test: 
	poetry run mojo run src/test.mojo

package:
	mkdir -p bin
	poetry run mojo package src/micrograd -o bin/micrograd.mojopkg

build:
	mkdir -p bin
	poetry run mojo build src/main.mojo -o bin/micrograd

run-build:
	./bin/micrograd
