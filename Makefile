.PHONY: pages clean

pages:
	make -C docs clean html
	git checkout gh-pages
	rm -rf *.html _*
	touch .nojekyll
	cp -r docs/build/html/* .

clean:
	git clean -df
