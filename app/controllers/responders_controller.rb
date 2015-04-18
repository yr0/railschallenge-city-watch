class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :update, :destroy]

  def index
    @responders = Responder.all
  end

  def show
  end

  def create
    @responder = Responder.new(responder_params)

    if @responder.save
      render :show, status: :created
    else
      render_error body: @responder.errors
    end
  end

  def update
    if @responder.update(responder_params)
      head :no_content
    else
      render json: @responder.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @responder.destroy

    head :no_content
  end

  private

  def set_responder
    @responder = Responder.find(params[:id])
  end

  def responder_params
    params[:responder][:type].downcase! if params[:responder][:type]
    params.require(:responder).permit(:type, :name, :capacity, :emergency_code)
  end
end
