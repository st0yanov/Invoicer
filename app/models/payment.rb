class Payment < ActiveRecord::Base
  belongs_to :invoice
end
