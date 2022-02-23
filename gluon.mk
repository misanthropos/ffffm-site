ifndef GLUON_SITEDIR
	include version.mk
else
	include $(GLUON_SITEDIR)/version.mk
endif

DEFAULT_GLUON_REMOTE := origin

GLUON_CHECKOUT ?= $(DEFAULT_GLUON_CHECKOUT)
GLUON_REMOTE ?= $(DEFAULT_GLUON_REMOTE)

checkout:
ifndef GLUON_SITEDIR
	git -C ../ checkout ${GLUON_CHECKOUT}
	git -C ../ pull ${GLUON_REMOTE} ${GLUON_CHECKOUT}
else
	git -C ${GLUON_SITEDIR}/../ checkout ${GLUON_CHECKOUT}
	git -C ${GLUON_SITEDIR}/../ pull ${GLUON_REMOTE} ${GLUON_CHECKOUT}
endif
