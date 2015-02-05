clean:
	rm -rf dash

output_dir: clean
	mkdir -p dash/prototope.docset/Contents/Resources/Documents/

clean_output: output_dir
	rm -f dash/prototope.docset/Contents/Resources/docSet.dsidx
	rm -f dash/prototope.docset/Contents/info.plist

copy_plist: clean_output
	cp info.plist dash/prototope.docset/Contents
	cp favicon.png dash/prototope.docset/icon.png

get_docs: copy_plist
	wget -r -p -nH --cut-dirs=1 -k http://localhost:4000/Prototope/ -P dash/prototope.docset/Contents/Resources/Documents/

deps:
	rm -rf env
	virtualenv env
	env/bin/pip install -r requirements.txt

docs: get_docs
	./env/bin/python gendoc.py

bundle:
	pushd dash; tar --exclude='.DS_Store' -cvzf Prototope.tgz prototope.docset; popd;
	mv dash/Prototope.tgz .
