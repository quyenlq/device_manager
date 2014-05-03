class BlockListsController < ApplicationController
	before_filter :admin_user

	def index
		@lists = BlockList.all
	end

	def destroy
		@list = BlockList.find(params[:id])
		@list.delete
		redirect_to block_lists_path
	end

	private
	def admin_user
		redirect_to root_path, warning: "You are not allowed to access this page" unless admin?
	end

end
