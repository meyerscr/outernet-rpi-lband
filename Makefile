.PHONY: pages clean

pages:
	make -C docs clean html
	git checkout gh-pages
	cp -r docs/build/html/* .

clean:
	git clean -df
