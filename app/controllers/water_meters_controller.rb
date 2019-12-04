# frozen_string_literal: true

class WaterMetersController < ApplicationController
  delegate :beginning_of_year, :end_of_year,
           to: :year

  def index
    fetch_water_meters
    @water_meter = WaterMeter.new
  end

  def create
    @water_meter = WaterMeter.new(water_meter_params)

    if @water_meter.save
      redirect_to water_meters_path
    else
      fetch_water_meters

      render :index
    end
  end

  def destroy
    year = params[:year].to_i
    month = params[:month].to_i

    if year.positive? && month.positive?
      WaterMeter.where(check_date: destroy_date_range(year, month)).destroy_all
      redirect_to water_meters_path
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  private

  def fetch_water_meters
    collection =
      WaterMeter
      .where(check_date: beginning_of_year..end_of_year)
      .order(:check_date)

    @water_meter_by_months =
      collection
      .group_by { |water_meter| water_meter.check_date.month }
      .each_with_object({}) do |(month, water_meters), result|
        result[month] = water_meters.last
      end
  end

  def year
    year = params[:year].to_i
    year = Date.current.year if year.zero?
    Date.new(year, 1, 1)
  end

  def water_meter_params
    params.require(:water_meter).permit(:check_date, :cold, :hot)
  end

  def destroy_date_range(year, month)
    date = Date.new(year, month, 1)

    date.beginning_of_month..date.end_of_month
  end
end
