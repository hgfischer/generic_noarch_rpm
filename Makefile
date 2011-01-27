NAME = generic_noarch_rpm
SUMMARY = Generic noarch RPM packaged project with GIT versioning integration
GROUP = Applications/Tools
LICENSE = CC
VENDOR = hgfischer
PREFIX = /opt

VERSION = $(shell git describe --abbrev=0 --match=[0-9]\.[0-9]\.[0-9])
ifeq ($(strip $(VERSION)),)
	VERSION = 0.0.0
endif
BUILD_STAMP = $(shell date +"%Y%m%d_%H%M")
# Get URL from remote GIT repo
URL = $(shell git config --get remote.origin.url)
ifeq ($(strip $(GIT_URL)),)
	URL = http://url.for.your.project.com/
endif

RELEASE = $(BUILD_STAMP)
PACKAGER = $(USER)
PROJROOT = $(shell pwd)

DIST_DIR = dist
TAR_DIR = tar
TAR_DIRS = bin etc log www
RPM_DIR = rpm
RPM_DIRS = SPECS RPMS SOURCES BUILD

all: 	rpm

init:	clean
	@echo Creating directories...
	@mkdir -p $(DIST_DIR)
	@for dir in $(RPM_DIRS); do \
		mkdir -p $(RPM_DIR)/$$dir; \
	done

preptar:	init
	@echo Copying files to generate tarball...
	@for dir in $(TAR_DIRS); do \
		mkdir -p $(TAR_DIR)/$$dir/$(NAME); \
		cp -Rp $$dir/* $(TAR_DIR)/$$dir/$(NAME); \
	done

tar:	preptar
	@echo Generating tarball...
	@cd $(PROJROOT)/$(TAR_DIR); \
		tar cf $(PROJROOT)/$(RPM_DIR)/SOURCES/$(NAME).tar .

rpm:	tar
	@echo Calling rpmbuild...
	@cp $(NAME).spec $(RPM_DIR)/SPECS/

	@cd $(PROJROOT)/$(RPM_DIR)/SPECS ; \
		rpmbuild -bb \
			--buildroot="$(PROJROOT)/$(RPM_DIR)/BUILD/$(NAME)" \
			--define "_topdir $(PROJROOT)/$(RPM_DIR)" \
			--define "name $(NAME)" \
			--define "summary $(SUMMARY)" \
			--define "version $(VERSION)" \
			--define "release $(RELEASE)" \
			--define "url _$(GIT_URL)_" \
			--define "license $(LICENSE)" \
			--define "group $(GROUP)" \
			--define "vendor $(VENDOR)" \
			--define "packager $(PACKAGER)" \
			--define "prefix $(PREFIX)" \
			--define "source_dir $(PROJROOT)/$(RPM_DIR)/SOURCES" \
			$(NAME).spec
	@echo Copying generated RPM to dist dir,,,
	@cp $(PROJROOT)/$(RPM_DIR)/RPMS/noarch/*.rpm $(PROJROOT)/$(DIST_DIR)/

clean:
	@echo Cleaning temporary dirs...
	@rm -rf $(TAR_DIR)
	@rm -rf $(RPM_DIR)
	@rm -rf $(DIST_DIR)

