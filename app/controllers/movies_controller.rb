class MoviesController < InheritedResources::Base
  before_action :authenticate_user!

  def edit
    @movie = Movie.find_by(id: params[:id])
    @movie.image.cache! unless @movie.image.blank?
  end

  private
    def movie_params
      params.require(:movie).permit(:title, :outline, :director, :performer, :year, :preview, :image, :image_cache, :article, :movie)
    end

end
