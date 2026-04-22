#!/bin/sh

bundle exec rails assets:precompile
bundle exec rails server -p ${PORT:-80} -b '0.0.0.0'
