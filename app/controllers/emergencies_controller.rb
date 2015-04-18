class EmergenciesController < ApplicationController
  before_action :set_emergency, only: [:show, :update, :destroy]

  def index
    @emergencies = Emergency.all
  end

  def show
  end

  def create
    @emergency = Emergency.new(emergency_params)

    if @emergency.save
      render :show, status: :created
    else
      render_error body: @emergency.errors
    end
  end

  def update
    @emergency = Emergency.find(params[:id])

    if @emergency.update(emergency_params)
      head :no_content
    else
      render_error body: @emergency.errors
    end
  end

  def destroy
    @emergency.destroy

    head :no_content
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:id])
  end

  def emergency_params
    pars = [:code, :fire_severity, :medical_severity,
            :police_severity]
    pars << [:resolved_at] if request.put?

    params.require(:emergency).permit pars
  end
end
