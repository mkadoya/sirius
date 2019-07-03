class HomeController < ApplicationController
  def top
    @user_id = cookies[:user_id].presence || 0
    @articles = Article.order(id: :desc).first(10)
    @laptops = Array.new
    @result_displayed = false
    @categories = {}

    # 結果の表示判定
    if (Result.where(user_id: @user_id).count > 0)
      @result_displayed = true
      category_array = Result.where(user_id:@user_id).pluck(:category).uniq
      category_array.each do |category|
        name = Category.find_by(category: category).name
        @categories[category] = name
      end
    end

    # 人気のノートパソコンの表示
    @laptop = {"image" => Item.find_by(series:"Surface Pro 6 128GB").image, "url" => "89", "series" => "Surface Pro 6 128GB"}
    @laptops.push(@laptop)
    @laptop = {"image" => Item.find_by(series:"Surface Laptop 2 LQL 128GB").image, "url" => "77", "series" => "Surface Laptop 2 LQL 128GB"}
    @laptops.push(@laptop)
    @laptop = {"image" => Item.find_by(series:"VivoBook S13 S330UA").image, "url" => "10", "series" => "VivoBook S13 S330UA"}
    @laptops.push(@laptop)
    @laptop = {"image" => Item.find_by(series:"Ideapad S130").image, "url" => "46", "series" => "Ideapad S130 "}
    @laptops.push(@laptop)
    @laptop = {"image" => Item.find_by(series:"ZenBook 14 UX430UA").image, "url" => "16", "series" => "ZenBook 14 UX430UA"}
    @laptops.push(@laptop)


  end

  def movie
    @tags = Tag.all.pluck(:name).uniq
    @movies = Movie.all
  end

  def show
    @movie = Movie.find_by(id: params[:id])
    render json: @movie
  end

  def tagToTag
    all_tags = Tag.all
    @tagArray = Array.new
    if params[:tag] == "0"
      all_tags.each do |tag|
        tags = Array.new
        tags_movie = Tag.where(name: tag.name).pluck(:movie_id).uniq
        isFirst = true
        tags_movie.each do |movie|
          temp_tags = Tag.where(movie_id: movie).pluck(:name).uniq
          if isFirst
            tags = temp_tags
            isFirst = false
          end
          temp_tags.each do |temp_tag|
            unless tags.include?(temp_tag)
              tags.push(temp_tag)
            end
          end
        end
        tags.delete(tag.name)
        hash = {tag: tag.name, tags: tags}
        @tagArray.push(hash)
      end
    else
      tags_movie = Tag.where(name: params[:tag]).pluck(:movie_id).uniq
      isFirst = true
      tags = Array.new
      tags_movie.each do |movie|
        temp_tags = Tag.where(movie_id: movie).pluck(:name).uniq
        if isFirst
          tags = temp_tags
          isFirst = false
        end
        temp_tags.each do |temp_tag|
          unless tags.include?(temp_tag)
            tags.push(temp_tag)
          end
        end
      end
      tags.delete(params[:tag])
      hash = {tag: params[:tag], tags: tags}
      @tagArray.push(hash)
    end
    render json: @tagArray
  end

  def tag
    @tag_names = params[:name].split(",")
    @movies = Array.new
    isFirst = true
    if params[:name] == "0"
      tags = Tag.all.pluck(:name).uniq
      all_movies = Movie.all
      movies_list = Array.new
      all_movies.each do |movie|
        movie_hash = {id: movie.id, image: movie.image.url}
        movies_list.push(movie_hash)
      end
      hash = {tag: "all", movies: movies_list }
      @movies.push(hash)
      tags.each do |tag|
        tag_movies = Tag.where(name:tag).all
        movies_list = []
        tag_movies.each do |tag_movie|
          movie_image = Movie.find_by(id:tag_movie.movie_id ).image.url
          movie_hash = {id: tag_movie.movie_id, image: movie_image}
          movies_list.push(movie_hash)
        end
        hash = {tag: tag, movies: movies_list }
        @movies.push(hash)
      end
    else
      movies_list = Array.new
      @tag_names.each do |name|
        tags = Tag.where(name: name).all
        unless tags.nil?
          if isFirst
            tags.each do |tag|
              movie = Movie.find_by(id: tag.movie_id)
              # @movies.push(movie)
              movie_hash = {id: movie.id, image: movie.image.url}
              movies_list.push(movie_hash)
            end
            isFirst = false
          else
            new_movies = Array.new
            tags.each do |tag|
              movie = Movie.find_by(id: tag.movie_id)
              # new_movies.push(movie)
              movie_hash = {id: movie.id, image: movie.image.url}
              new_movies.push(movie_hash)
            end
            # @movies = @movies & new_movies
            movies_list = movies_list & new_movies
          end
        end
      end
      hash = {tag: @tag_names, movies: movies_list }
      @movies.push(hash)
    end
    render json: @movies
  end

  def movieToTag
    @movie_ids = params[:ids].split(",")
    if params[:ids] == "0"
      @tags = Tag.all.pluck(:name).uniq
    else
      @tags = Array.new
      isFirst = true
      @movie_ids.each do |movie_id|
        if isFirst
          first_tags = Tag.where(movie_id: movie_id).all
          first_tags.each do |tag|
            @tags.push(tag.name)
          end
          isFirst = false
        else
          temp_tags = Tag.where(movie_id: movie_id).all
          temp_tags.each do |temp_tag|
            pushFlag = true
            @tags.each do |tag|
              if tag == temp_tag.name
                pushFlag = false
              end
            end
            if pushFlag
              @tags.push(temp_tag.name)
            end
          end
        end
      end
    end
    render json: @tags
  end



  def checkTagAndMovie
    @data = params[:data].split(",")
    @result = false
    if @data.length == 2
      movie_id = @data[0]
      tag = @data[1]
      if Tag.where(movie_id: movie_id, name: tag).all.count > 0
        @result = true
      end
    end
    render json: @result
  end

end
