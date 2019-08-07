CURRENT_SIGN_SETTING := $(shell git config commit.gpgSign)

.PHONY: clean-pyc clean-build

help:
	@echo "clean-build - remove build artifacts"
	@echo "clean-pyc - remove Python file artifacts"
	@echo "lint - check style with flake8"
	@echo "test - run tests quickly with the default Python"
	@echo "test-all - run tests on every Python version with tox"
	@echo "release - package and upload a release"
	@echo "sdist - package"

clean: clean-build clean-pyc

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

lint36:
	tox -e lint-py36

lint37:
	tox -e lint-py37

lint: lint36 lint37

lint-roll:
	isort --recursive vips_utils tests
	black vips_utils tests
	$(MAKE) lint

test:
	py.test tests

test-all:
	tox

release: clean
	git config commit.gpgSign true
	bumpversion $(bump)
	git push upstream && git push upstream --tags
	python setup.py sdist bdist_wheel
	twine upload dist/*
	git config commit.gpgSign "$(CURRENT_SIGN_SETTING)"

sdist: clean
	python setup.py sdist bdist_wheel
	ls -l dist

build-docs:
	sphinx-apidoc -o docs/ . setup.py "*conftest*" "tests"
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	$(MAKE) -C docs doctest

mac-docs: build-docs
	open docs/_build/html/index.html

linux-docs: build-docs
	readlink -f docs/_build/html/index.html
