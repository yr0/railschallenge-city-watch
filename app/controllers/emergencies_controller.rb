class EmergenciesController < ApplicationController
  before_action :set_emergency, only: [:show, :update, :destroy]

  # GET /emergencies
  # GET /emergencies.json
  def index
    @emergencies = Emergency.all

    render json: @emergencies
  end

  # GET /emergencies/1
  # GET /emergencies/1.json
  def show
    render json: @emergency
  end

  # POST /emergencies
  # POST /emergencies.json
  def create
    @emergency = Emergency.new(emergency_params)

    if @emergency.save
      render json: @emergency, status: :created, location: @emergency
    else
      render json: @emergency.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /emergencies/1
  # PATCH/PUT /emergencies/1.json
  def update
    @emergency = Emergency.find(params[:id])

    if @emergency.update(emergency_params)
      head :no_content
    else
      render json: @emergency.errors, status: :unprocessable_entity
    end
  end

  # DELETE /emergencies/1
  # DELETE /emergencies/1.json
  def destroy
    @emergency.destroy

    head :no_content
  end

  private

    def set_emergency
      @emergency = Emergency.find(params[:id])
    end

    def emergency_params
      params.require(:emergency).permit(:code, :fire_severity, :medical_severity,
                                        :police_severity, :full_response, :resolved_at)
    end
end
