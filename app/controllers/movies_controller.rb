class MoviesController < InheritedResources::Base
  before_action :authenticate_user!

  def edit
    @movie = Movie.find_by(id: params[:id])
    @movie.image.cache! unless @movie.image.blank?
  end

  def updateItemMaster
    category = "movie"
    movies = Movie.all
    itemMasters = ItemMaster.where(category: category).all.pluck(:name).uniq
    movies.each do |movie|
      unless itemMasters.include?(movie.title)
        tags = Tag.where(movie_id: movie.id).all.pluck(:name).uniq
        isfirst = true
        taglist = ""
        tags.each do |tag|
          if isfirst
            taglist = tag
            isfirst = false
          else
            taglist = taglist + "," + tag
          end
        end
        newItem = ItemMaster.new(category: category, movie_id: movie.id, name: movie.title,image: movie.image.url, tags: taglist)
        newItem.save
      else
        tags = Tag.where(movie_id: movie.id).all.pluck(:name).uniq
        isfirst = true
        taglist = ""
        tags.each do |tag|
          if isfirst
            taglist = tag
            isfirst = false
          else
            taglist = taglist + "," + tag
          end
        end
        updateflag = false
        if ItemMaster.where(name:movie.title).all.count > 0
          updateItem = ItemMaster.find_by(name:movie.title)
          if updateItem.image != movie.image.url
            updateflag = true
          end
          if updateItem.tags != taglist
            updateflag = true
          end
          if updateflag
            updateItem.image = movie.image.url
            updateItem.tags = taglist
            updateItem.save
          end
        end
      end
    end
    redirect_to :controller => "movies", :action => "index" and return
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
