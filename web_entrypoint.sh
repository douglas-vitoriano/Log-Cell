#!/bin/sh
set -e

bundle exec rails assets:precompile

bundle exec rails runner "
  if User.exists?(email: ENV.fetch('ADMIN_EMAIL', 'logcell@logcell.xyz'))
    puts 'Seeds ignorados — banco já populado.'
  else
    puts 'Rodando seeds...'
    load Rails.root.join('db/seeds.rb')
    puts 'Seeds concluídos.'
  end
"

bundle exec rails server -p ${PORT:-80} -b '0.0.0.0'
