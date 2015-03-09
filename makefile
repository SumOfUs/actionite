.PHONY: test

gems:
	which gemset  || gem install gemset
	which dep || gem install dep
	gemset init

install:
	dep install

server:
	env $$(cat .env) shotgun -o 0.0.0.0

console:
	env $$(cat .env) irb -r ./app

db:
	env $$(cat .env) ruby create_table.rb
