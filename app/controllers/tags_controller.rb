class TagsController < InheritedResources::Base
  before_action :authenticate_user!

  private
    def tag_params
      params.require(:tag).permit(:name, :movie_id, :value)
    end

end
