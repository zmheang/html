OUTPUT=$(abspath output/html)
HTMLS=$(OUTPUT)/multipage/*.html $(OUTPUT)/*.html
RESULTS=$(HTMLS) $(OUTPUT)/*.js

update-en:
	[ -d html ] || git clone https://github.com/whatwg/html.git --depth=1
	cd html && git checkout master source && git pull && cd ..
	mv html/source source
	rm -rf src/SUMMARY.en.md
	find src/ -name "*.en.html" -delete
	find src/ -type d -empty -delete
	node ./bin/split.js

build-zh:
	node ./bin/merge.js > html/source
	[ -d html-build ] || git clone https://github.com/whatwg/html-build.git --depth=1
	HTML_OUTPUT=$(OUTPUT) bash html-build/build.sh -n
	sed -i \
		-e 's/"\/\?multipage/"\/html\/multipage/g' \
		-e "s/'\/\?multipage/'\/html\/multipage/g" \
		-e 's/=\/\?link-fixup.js/=\/html\/link-fixup.js/g' \
		-e "s/'\/\?fonts\//'\/html\/fonts\//g" \
		-e 's/=\/\?images\//=\/html\/images\//g' \
		-e 's/=\/\?demos\//=\/html\/demos\//g' \
		-e 's/=\/\?entities.json/=\/html\/entities.json/g' \
		$(RESULTS)
	sed -i -r \
		-e 's/standard.css>/standard.css><link rel=stylesheet href=\/html\/resources\/zh-cn.css>/' \
		-e 's/issue-url=[^ ]+\s+src=[^ ]+/issue-url=https:\/\/github.com\/whatwg-cn\/html\/issues\/new src=\/html\/resources\/file-issue.js/' \
		-e 's/https:\/\/resources\.whatwg\.org\/dfn\.js/\/html\/resources\/dfn.js/' \
		-e '$$a\<script src=\/html\/resources\/zh-cn.js></script>' \
		$(HTMLS)
	node ./bin/json-pretify.js ${OUTPUT}/multipage/fragment-links.json
	rm -rf $(OUTPUT)/resources && cp -r resources $(OUTPUT)

# Split subtree before deploy:
# git subtree split --prefix output/html -b gh-pages
deploy:
	if [ -n "$$(git status --porcelain)" ]; then \
		echo "there are changes, please commit to master first" && exit 1; \
	fi
	git add -f output/html
	git commit -m 'dist'
	git push origin `git subtree split --prefix output/html`:gh-pages --force
	git reset output/html
	git reset HEAD^

deploy-force:
	git push origin `git subtree split --prefix output/html`:gh-pages --force

clean-cache:
	rm -rf html-build/.cache

update-term:
	node ./bin/update-term.js

# `npm install http-server` first
serve:
	echo open http://localhost:8899/html
	http-server -p 8899 ./output
