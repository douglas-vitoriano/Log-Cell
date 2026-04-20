#!/bin/sh
set -e

bundle exec rails assets:precompile

bundle exec rails db:migrate

bundle exec rails runner "
  unless User.exists?(email: ENV.fetch('ADMIN_EMAIL', 'logcell@logcell.xyz'))
    puts 'Rodando seeds...'
    load Rails.root.join('db/seeds.rb')
    puts 'Seeds concluídos.'
  else
    puts 'Seeds ignorados — banco já populado.'
  end
"

bundle exec rails server -p ${PORT:-80} -b '0.0.0.0'
