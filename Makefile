.PHONY: all
all: dist

.PHONY: build
build: check-all docs test-all

.PHONY: check-all
check-all: check-format check-types

.PHONY: check-format
check-format:
	ruff check
	ruff format --check

.PHONY: format
format:
	ruff check --fix
	ruff format

.PHONY: check-types
check-types:
	mypy mitiq --show-error-codes

.PHONY: clean
clean:
	rm -rf dist
	rm -rf mitiq.egg-info
	rm -rf .pytest_cache/

.PHONY: dist
dist:
	python setup.py sdist

.PHONY: docs
docs:
	make -C docs html

.PHONY: docs-clean
docs-clean:
	make -C docs clean
	make -C docs html

.PHONY: linkcheck
linkcheck:
	make -C docs linkcheck

.PHONY: install
install:
	pip install -e .[development]

.PHONY: requirements
requirements: requirements.txt
	pip install -r requirements.txt

.PHONY: test
test:
	pytest -n auto -v --cov=mitiq --cov-report=term --cov-report=xml --ignore=mitiq/interface/mitiq_pyquil

.PHONY: test-%
test-%:
	pytest -n auto -v --cov=mitiq --cov-report=term --cov-report=xml */$(*)/*

.PHONY: test-pyquil
test-pyquil:
	pytest -v --cov=mitiq --cov-report=term --cov-report=xml mitiq/interface/mitiq_pyquil

.PHONY: test-all
test-all:
	pytest -n auto -v --cov=mitiq --cov-report=term --cov-report=xml
