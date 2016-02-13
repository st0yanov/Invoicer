class Payment < ActiveRecord::Base
  belongs_to :invoice

  validates :invoice, :gateway, :date, :transaction_id, :amount, presence: {
    message: I18n.t('validation.presence')
  }

  validates :gateway, length: {
    in: 2..32,
    too_short: I18n.t('validation.length.too_short'),
    too_long: I18n.t('validation.length.too_long')
  }

  validates :transaction_id, length: {
    in: 1..64,
    too_short: I18n.t('validation.length.too_short'),
    too_long: I18n.t('validation.length.too_long')
  }

  validates :amount, numericality: {
    message: I18n.t('validation.amount.numericality')
  }
end
