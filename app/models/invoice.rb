class Invoice < ActiveRecord::Base
  belongs_to :partner
  has_many :payments

  validates :partner, presence: {
    message: I18n.t('validation.presence')
  }
end
