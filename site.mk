ifndef GLUON_SITEDIR
	include version.mk
else
	include $(GLUON_SITEDIR)/version.mk
endif

# GIT Properties
ifndef GLUON_SITEDIR
	GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
	COMMIT_DESCRIPTION := $(shell git describe --tags --long)
	BUILD_DATESTAMP := $(shell [ -f build_date ] && cat build_date || date '+%Y%m%d')
	GIT_COMMIT := $(shell git rev-parse --short HEAD)
	GLUON_COMMIT := $(shell git -C .. rev-parse --short HEAD)
else
	GIT_BRANCH := $(shell git -C $(GLUON_SITEDIR) rev-parse --abbrev-ref HEAD)
	COMMIT_DESCRIPTION := $(shell git -C $(GLUON_SITEDIR) describe --tags --long)
	BUILD_DATESTAMP := $(shell [ -f $(GLUON_SITEDIR)/build_date ] && cat $(GLUON_SITEDIR)/build_date || date '+%Y%m%d')
	GIT_COMMIT := $(shell git -C $(GLUON_SITEDIR) rev-parse --short HEAD)
	GLUON_COMMIT := $(shell git -C $(GLUON_SITEDIR)/.. rev-parse --short HEAD)
endif
GIT_BRANCH := $(shell test -n "${CI_COMMIT_BRANCH}" && echo "${CI_COMMIT_BRANCH}" || echo "${GIT_BRANCH}")

### Build Release Name
# Default: Goto Experimental
DEFAULT_GLUON_BRANCH := experimental
DEFAULT_GLUON_RELEASE := $(DEFAULT_BASE_VERSION)-$(DEFAULT_GLUON_BRANCH)-$(BUILD_DATESTAMP)-$(GIT_COMMIT)-$(GLUON_COMMIT)
ifeq ($(GIT_BRANCH),next)
	# Next-Branch
	DEFAULT_GLUON_BRANCH := next
	DEFAULT_GLUON_RELEASE := $(DEFAULT_BASE_VERSION)-$(DEFAULT_GLUON_BRANCH)-$(BUILD_DATESTAMP)-$(GIT_COMMIT)-$(GLUON_COMMIT)
else ifeq ($(GIT_BRANCH),experimental)
		# RC-Branch
		DEFAULT_GLUON_BRANCH := experimental
		DEFAULT_GLUON_RELEASE := $(DEFAULT_BASE_VERSION)-$(DEFAULT_GLUON_BRANCH)-$(BUILD_DATESTAMP)-$(GIT_COMMIT)-$(GLUON_COMMIT)
else ifeq ($(GIT_BRANCH),stable)
	# RC-Branch
	DEFAULT_GLUON_BRANCH := rc
	DEFAULT_GLUON_RELEASE := $(DEFAULT_BASE_VERSION)-$(DEFAULT_GLUON_BRANCH)-$(BUILD_DATESTAMP)-$(GIT_COMMIT)-$(GLUON_COMMIT)
else ifeq ($(GIT_BRANCH),HEAD)
	# Determine TAG - if tagged set Version
	ifndef GLUON_SITEDIR
		GIT_TAG := $(shell git describe --exact-match --tags HEAD 2>/dev/null || echo false)
		ifneq ($(GIT_TAG),false)
			DEFAULT_GLUON_BRANCH := stable
			DEFAULT_GLUON_RELEASE := $(GIT_TAG)
		endif
	else
		GIT_TAG := $(shell git -C $(GLUON_SITEDIR) describe --exact-match --tags HEAD 2>/dev/null || echo false)
		ifneq ($(GIT_TAG),false)
			DEFAULT_GLUON_BRANCH := stable
			DEFAULT_GLUON_RELEASE := $(GIT_TAG)
		endif
	endif
endif

# Set final Branch and release

GLUON_AUTOUPDATER_BRANCH ?= $(DEFAULT_GLUON_BRANCH)
GLUON_AUTOUPDATER_ENABLED ?= 1
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

# Default priority for updates.
GLUON_PRIORITY ?= 0

# Languages to include
GLUON_LANGS ?= de

# region information for regulatory compliance
GLUON_REGION ?= eu

# Build only sysupgrade for deprecated
GLUON_DEPRECATED ?= 0

# Enable multidomain support
GLUON_MULTIDOMAIN := 1
