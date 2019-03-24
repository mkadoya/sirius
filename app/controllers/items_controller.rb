class ItemsController < ApplicationController
  def show
    # @item = Item.find_by(item_id: params[:item_id])
    @series = params[:series]
    @items = Item.where(series: @series).all

    @items_array = [@items.first]
    @items.each do |item|
      @items_array.push(item)
    end
    @items_array.shift
    @item = @items_array[0]
  end
  def series
    @series = "MacBook Air"
    @items = Item.where(series: @series).all

    @items_array = [@items.first]
    @items.each do |item|
      @items_array.push(item)
    end
    @items_array.shift
    @item = @items_array[0]

  end
end
