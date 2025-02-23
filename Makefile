# Usage:
# 'make dep' and 'make webtools' to install dependencies.
# 'make clean' to clear all work files
# 'make' to build css and js into static/
# 'make serve' to start dev webserver

NODE_VER = 14

JSFILES = index.js helpers.js data.js
JSFILES2 = Index.svelte Accounts.svelte Txns.svelte AccountForm.svelte TxnForm.svelte TxnDetail.svelte
JSFILES3 = Tablinks.svelte Journal.svelte Report.svelte SummaryRpt.svelte Setup.svelte 
JSFILES4 = UserLogin.svelte UserSignup.svelte UserPassword.svelte UserDel.svelte
JSFILES5 = SetupBooks.svelte BookForm.svelte SetupCurrencies.svelte CurrencyForm.svelte SetupUser.svelte

SRCS = mb.go util.go web.go user.go
SRCS2 = db.go dbdata.go dbrptdata.go

all: mb static/style.css static/bundle.js

nodejs:
	curl -fsSL https://deb.nodesource.com/setup_$(NODE_VER).x | sudo bash -
	sudo apt install nodejs
	sudo npm install -g npx

dep:
	go env -w GO111MODULE=auto
	go get -u github.com/mattn/go-sqlite3
	go get -u golang.org/x/crypto/bcrypt
	go get -u github.com/xuri/excelize

webtools:
	npm install --save-dev tailwindcss
	npm install --save-dev postcss
	npm install --save-dev postcss-cli
	npm install --save-dev cssnano
	npm install --save-dev svelte
	npm install --save-dev rollup
	npm install --save-dev rollup-plugin-svelte
	npm install --save-dev @rollup/plugin-node-resolve

static/style.css: twsrc.css tailwind.config.js
	#npx tailwind build twsrc.css -o twsrc.o 1>/dev/null
	#npx postcss twsrc.o > static/style.css
	npx tailwind -i twsrc.css -o static/style.css 1>/dev/null

static/bundle.js: $(JSFILES) $(JSFILES2) $(JSFILES3) $(JSFILES4) $(JSFILES5)
	npx rollup -c

mb: $(SRCS) $(SRCS2)
	go build -o mb $(SRCS) $(SRCS2) $(SRCS3)

importer: importer.go dbdata.go db.go util.go
	go build -o importer importer.go dbdata.go db.go util.go

clean:
	rm -rf mb static/*.js static/*.css static/*.map

serve:
	python -m SimpleHTTPServer

