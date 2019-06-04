class TagsController < InheritedResources::Base

  private

    def tag_params
      params.require(:tag).permit(:name, :item_id, :value)
    end

end
