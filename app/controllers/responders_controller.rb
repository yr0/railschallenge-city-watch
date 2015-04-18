class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :update, :destroy]

  # GET /responders
  # GET /responders.json
  def index
    @responders = Responder.all

    render json: @responders
  end

  # GET /responders/1
  # GET /responders/1.json
  def show
    render json: @responder
  end

  # POST /responders
  # POST /responders.json
  def create
    @responder = Responder.new(responder_params)

    if @responder.save
      render json: @responder, status: :created, location: @responder
    else
      render json: @responder.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /responders/1
  # PATCH/PUT /responders/1.json
  def update
    @responder = Responder.find(params[:id])

    if @responder.update(responder_params)
      head :no_content
    else
      render json: @responder.errors, status: :unprocessable_entity
    end
  end

  # DELETE /responders/1
  # DELETE /responders/1.json
  def destroy
    @responder.destroy

    head :no_content
  end

  private

    def set_responder
      @responder = Responder.find(params[:id])
    end

    def responder_params
      params.require(:responder).permit(:type, :name, :capacity, :on_duty, :emergency_id)
    end
end
