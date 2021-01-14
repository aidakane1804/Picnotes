class EdFluencersController < ApplicationController
	before_action :find_interview, only: [:show]

	def index
		@interviews = EdFluencer.all
	end	

	

	def show;end


	private

  def find_interview
  	@interview = EdFluencer.find(params[:id]) if params[:id].present?
  end
end