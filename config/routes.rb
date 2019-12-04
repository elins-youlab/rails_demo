# frozen_string_literal: true

Rails.application.routes.draw do
  resources :water_meters, path: '/', only: [:create] do
    collection do
      get '/(:year)',
          action: :index,
          defaults: { year: Date.current.year },
          as: :by_year

      delete '/:year/:month', action: :destroy
    end
  end
end
