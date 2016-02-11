require 'active_model'
#require 'eik_validator'
require 'valvat'

class Partner < ActiveRecord::Base
  validates :first_name, :last_name, :country, :city, :address, :phone_number, presence: {
    message: I18n.t('validation.presence')
  }

  validates :first_name, :last_name, :city, length: {
    in: 2..32,
    too_short: I18n.t('validation.length.too_short'),
    too_long: I18n.t('validation.length.too_long')
  }

  validates :country, inclusion: {
    in: ['BG', 'DE', 'UK'],
    message: I18n.t('validation.inclusion')
  }

  validates :postcode, numericality: {
    only_integer: true,
    message: I18n.t('validation.postcode.numericality')
  }

  validates :address, length: {
    maximum: 64,
    too_long: I18n.t('validation.length.too_long')
  }

  validates :phone_number, length: {
    maximum: 16,
    too_long: I18n.t('validation.length.too_long')
  }

  validates :company_name, length: {
    in: 2..32,
    too_short: I18n.t('validation.length.too_short'),
    too_long: I18n.t('validation.length.too_long')
  }, if: Proc.new { |a| a.company_name.present? }

  validates :company_name, uniqueness: {
    case_sensitive: false,
    message: I18n.t('validation.company_name.uniqueness')
  }, if: Proc.new { |a| a.company_name.present? }

  #TODO - Fix the eik_validation gem.
  #validates :eik, eik: {
  #  message: I18n.t('validation.eik.validity')
  #}, if: Proc.new { |a| a.eik.present? }

  validates :eik, uniqueness: {
    case_sensitive: false,
    message: I18n.t('validation.eik.uniqueness')
  }, if: Proc.new { |a| a.eik.present? }

  validates :vat_id, valvat: {
    lookup: false,
    message: I18n.t('validation.vat_id.validity')
  }, if: Proc.new { |a| a.vat_id.present? }

  validates :vat_id, uniqueness: {
    case_sensitive: false,
    message: I18n.t('validation.vat_id.uniqueness')
  }, if: Proc.new { |a| a.vat_id.present? }
end
