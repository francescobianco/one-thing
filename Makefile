
## ===
## Git
## ===

push:
	@git add .
	@git commit -am "Push updates"
	@git push


## ====
## Test
## ====

test:
	@bash +x one-thing.sh
