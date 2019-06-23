class MoviesController < InheritedResources::Base
  before_action :authenticate_user!

  def edit
    @movie = Movie.find_by(id: params[:id])
    @movie.image.cache! unless @movie.image.blank?
  end

  # def show
  #   @movie = Movie.find_by(id: params[:id])
  #   render 'show', formats: 'json', handlers: 'jbuilder'
  # end

  private
    def movie_params
      params.require(:movie).permit(:title, :outline, :director, :performer, :year, :preview, :image, :image_cache, :article, :movie, :youtube, :netflix, :amazonprime, :hulu, :filmarks)
    end

end
