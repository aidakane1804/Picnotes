class EdFluencersController < ApplicationController
	before_action :find_interview, only: [:show]

	def index
		ed_fluencers_meta_tags
		@interviews = EdFluencer.all
	end	

	

	def show
		ed_fluencers_meta_tags
	end


	private

  def find_interview
  	@interviews = EdFluencer.all
  	@interview = EdFluencer.find(params[:id]) if params[:id].present?
  end
end