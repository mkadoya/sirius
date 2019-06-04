class MoviesController < InheritedResources::Base
  
  private

    def movie_params
      params.require(:movie).permit(:title, :outline, :director, :performer, :year, :preview, :image, :article, :movie)
    end

end
