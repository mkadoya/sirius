class ItemsController < ApplicationController
  def show
    @item = Item.find_by(item_id: params[:item_id])
  end
end
