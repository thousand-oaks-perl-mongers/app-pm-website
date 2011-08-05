.PHONY: \
	crank \
	clean

BUILD=build
SOURCE_DIR=include/source
# FIXME *.pm.org should be retrieved dynamically from somewhere else
SOURCE_TAR_DIR_NAME=someplace.pm.org-`date +%Y%m%d`

default: crank

crank: clean
	mkdir -p $(BUILD)/ || true > /dev/null 2>&1
	perl crank --buildpath=$(BUILD)
	mkdir -p $(SOURCE_DIR)/$(SOURCE_TAR_DIR_NAME)/
	rsync --exclude='.git' --exclude='source' \
	    --exclude='presentations' --archive --relative \
	    crank Makefile README LICENSE template/page.tt include/ \
	    $(SOURCE_DIR)/$(SOURCE_TAR_DIR_NAME)/
	cd $(SOURCE_DIR) && \
	    tar zcf $(SOURCE_TAR_DIR_NAME).tar.gz \
	    $(SOURCE_TAR_DIR_NAME)/
	rm -rf $(SOURCE_DIR)/$(SOURCE_TAR_DIR_NAME)/
	rsync --archive include/* $(BUILD)/

clean:
	rm -rf $(SOURCE_DIR)
	rm -rf $(BUILD)

#test: crank
#	prove t/html.t

#sync: crank
#	rsync -a --delete --verbose \
#	    $(BUILD)/ root/
