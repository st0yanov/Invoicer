class Payment < ActiveRecord::Base
  belongs_to :invoice

  validates :gateway, :date, :transaction, :value, presence: {
    message: I18n.t('validation.presence')
  }

  validates :gateway, length: {
    in: 2..32,
    too_short: I18n.t('validation.length.too_short'),
    too_long: I18n.t('validation.length.too_long')
  }

  validates :transaction, length: {
    in: 1..64,
    too_short: I18n.t('validation.length.too_short'),
    too_long: I18n.t('validation.length.too_long')
  }

  validates :value, numericality: {
    message: I18n.t('validation.value.numericality')
  }
end
