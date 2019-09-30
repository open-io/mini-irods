.PHONY: build

build: build_irods


build_irods:
	docker build -t mini-irods ./irods
