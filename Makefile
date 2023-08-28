
## ===
## Git
## ===

push:
	@git add .
	@git commit -am "Push updates"
	@git push

## ===
## Git
## ===

install:
	@install -m 0755 one-thing /usr/local/bin/one-thing

## ====
## Test
## ====

test:
	@bash +x one-thing.sh
