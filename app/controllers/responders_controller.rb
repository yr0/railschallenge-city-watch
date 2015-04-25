class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :update, :destroy]

  def index
    if params[:show] == 'capacity'
      render json: { capacity: Responder.capacity_report }
      return
    else
      @responders = Responder.all
    end
  end

  def create
    @responder = Responder.new(create_responder_params)

    if @responder.save
      render :show, status: :created
    else
      render_error body: @responder.errors
    end
  end

  def update
    if @responder.update(update_responder_params)
      render :show, status: :ok
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
    @responder = Responder.find_by!(name: params[:id])
  end

  def create_responder_params
    params[:responder][:type].downcase! if params[:responder][:type]
    params.require(:responder).permit(:type, :name, :capacity)
  end

  def update_responder_params
    params.require(:responder).permit(:on_duty)
  end
end
