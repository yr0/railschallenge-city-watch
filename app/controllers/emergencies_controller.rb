class EmergenciesController < ApplicationController
  before_action :set_emergency, only: [:show, :update, :destroy]

  def index
    @emergencies = Emergency.includes(:responders)
  end

  def create
    @emergency = Emergency.create!(create_emergency_params)
    render :show, status: :created
  end

  def update
    @emergency.update!(update_emergency_params)
    render :show, status: :ok
  end

  def destroy
    @emergency.destroy
    head :no_content
  end

  private

  def set_emergency
    @emergency = Emergency.find_by!(code: params[:id])
  end

  def create_emergency_params
    params.require(:emergency).permit [:code, :fire_severity, :medical_severity,
                                       :police_severity]
  end

  def update_emergency_params
    params.require(:emergency).permit [:fire_severity, :medical_severity,
                                       :police_severity, :resolved_at]
  end
end
