class BlockListsController < ApplicationController
  def index
  	@lists = BlockList.all
  end

  def destroy
  	@list = BlockList.find(params[:id])
  	@list.delete
  	redirect_to block_lists_path
  end
end
