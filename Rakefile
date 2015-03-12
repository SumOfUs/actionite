task :gems do
  `which gemset  || gem install gemset`
  `which dep || gem install dep`
  `gemset init`
end

task :install do
  `dep install`
end

task :server do
  `env $(cat .env) shotgun -o 0.0.0.0`
end

task :console do
  `env $(cat .env) irb -r ./app`
end

task :db do
  `env $(cat .env) ruby ./db/create_table.rb`
end

task :test do
  puts `cutest ./tests/*.rb`
end

task :seed do
  `env $(cat .env) ruby seed.rb`
end
