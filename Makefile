
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

DEBUILD_OPTS :=
.PHONY: debuild
debuild:
	cd mlton ; debuild -S -d -sa -pgpg2 $(DEBUILD_OPTS)
