EXTENSIONS:=embroider embroider_params embroider_simulate embroider_update

# This gets the branch name or the name of the tag
VERSION:=$(TRAVIS_BRANCH)
OS:=$(shell uname)
ARCH:=$(shell uname -m)

dist: distclean locales
	bin/build-dist $(EXTENSIONS)
	cp *.inx dist
	mv locales dist/inkstitch/bin
	if [ "$$BUILD" = "windows" ]; then \
		cd dist; zip -r ../inkstitch-$(VERSION)-win32.zip *; \
	else \
    	cd dist; tar zcf ../inkstitch-$(VERSION)-$(OS)-$(ARCH).tar.gz *; \
	fi

distclean:
	rm -rf build dist *.spec *.tar.gz

messages.po: embroider*.py inkstitch.py
	rm -f messages.po
	xgettext embroider*.py inkstitch.py

.PHONY: locales
locales:
	# message files will look like this:
	#   translations/messages_en_US.po
	if ls translations/*.po > /dev/null 2>&1; then \
		for po in translations/*.po; do \
			lang=$${po%.*}; \
			lang=$${lang#*_}; \
			mkdir -p locales/$$lang/LC_MESSAGES/; \
			msgfmt $$po -o locales/$$lang/LC_MESSAGES/inkstitch.mo; \
		done; \
	else \
		mkdir -p locales; \
	fi
