# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Water meters page', type: :system do
  before { driven_by :selenium, using: :firefox }

  before { visit '/' }

  it 'have a right title' do
    expect(page).to have_text('Показатели счетчиков воды')
  end
end
