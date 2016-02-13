module SettingsHelpers
  def get_setting(name)
    setting = Setting.find_by(setting: name)
    setting.value
  end

  def set_setting(name, value)
    setting = Setting.find_by(setting: name)
    setting.value = value
    setting.save!
  end
end
