class Invoice < ActiveRecord::Base
  belongs_to :partner
  has_many :payments
end
