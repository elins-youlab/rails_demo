# frozen_string_literal: true

module WaterMetersHelper
  def month_name(month_number)
    I18n.t('month_names')[month_number]
  end
end
