.PHONY: build

build: build_irods

build_irods:
	docker build -t mini-irods ./irods

test: test_irods

test_irods:
	./test/run.sh
