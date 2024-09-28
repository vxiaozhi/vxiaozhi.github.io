gitbook_serve:
	docker run -it --rm -v ./docs:/srv/gitbook -w /srv/gitbook  -p 4000:4000  fellah/gitbook:3.2.1

gitbook_build:
	docker run -it --rm -v ./docs:/srv/gitbook -v ./build_html:/srv/html  -w /srv/gitbook  fellah/gitbook:3.2.1 gitbook build . /srv/html

set_build_html_mode:
	chown -R lighthouse ./build_html

gitbook_init_test:
	docker run -it --rm -v ./test/:/srv/gitbook -w /srv/gitbook fellah/gitbook gitbook init

clean:
	rm -rvf  ./test ./build_html

