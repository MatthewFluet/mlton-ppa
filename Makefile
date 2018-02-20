
all:


MLTON_VERSION=20180207

.PHONY: init
init:
	wget http://downloads.sourceforge.net/mlton/mlton-$(MLTON_VERSION).src.tgz
	mv mlton-$(MLTON_VERSION).src.tgz mlton_$(MLTON_VERSION).orig.tar.gz
	tar xzf mlton_$(MLTON_VERSION).orig.tar.gz
	mv mlton-$(MLTON_VERSION)/* mlton/
	rmdir mlton-$(MLTON_VERSION)

.PHONY: clean
clean:
	git clean -x -d -f

UBUNTU_SERIES_VERSION :=
UBUNTU_SERIES_NAME := xenial
DEBUILD_OPTS :=
.PHONY: debuild
debuild:
	cp mlton/debian/changelog changelog.bak
	cp mlton/debian/patches/series series.bak
	cat changelog.bak | \
		sed '1 s/UBUNTUSERIESNAME/$(UBUNTU_SERIES_NAME)/' | \
		if [ -n "$(UBUNTU_SERIES_VERSION)" ]; then sed '1 s/)/~ubuntu$(UBUNTU_SERIES_VERSION))/'; else cat; fi \
		> mlton/debian/changelog
	if [ "$(UBUNTU_SERIES_NAME)" = "trusty" ]; then \
		cat series.bak | \
			grep -v "stack-hardening.patch" \
			> mlton/debian/patches/series; \
	fi
	cd mlton ; debuild -S -d -sa -pgpg2 $(DEBUILD_OPTS)
	cat changelog.bak > mlton/debian/changelog
	cat series.bak > mlton/debian/patches/series
	rm changelog.bak series.bak

.PHONY: debuild-all
debuild-all:
	$(MAKE) UBUNTU_SERIES_VERSION=14.04 UBUNTU_SERIES_NAME=trusty debuild
	$(MAKE) UBUNTU_SERIES_VERSION= UBUNTU_SERIES_NAME=xenial debuild
