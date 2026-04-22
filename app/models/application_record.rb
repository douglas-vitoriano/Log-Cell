class ApplicationRecord < ActiveRecord::Base
  include Nanoidable

  primary_abstract_class
end
