class TagsController < InheritedResources::Base
  before_action :authenticate_user!

  def updateTagMaster

    tagmasters = TagMaster.all

    # Movieの処理
    movie_tags = Tag.where(movie_id: 0..Float::INFINITY).all.pluck(:name).uniq

    # Movieの追加処理
    movie_tags.each do |movie_tag|
      #もしTagMasterにMovieのタグが含まれていなかったらTagMasterにタグを追加する
      unless tagmasters.pluck(:name).uniq.include?(movie_tag)
        newTagMaster = TagMaster.new(name: movie_tag, categories: "movie")
        newTagMaster.save
      #もしTagMasterにMovieのタグが含まれていなかったら
      else
        unless tagmasters.where(name: movie_tag).where("categories LIKE ?", "%movie%").all.count > 0
          tagmaster = tagmasters.find_by(name: movie_tag)
          categories = tagmasters.find_by(name: "SF").categories + "," + "movie"
          tagmaster.category = categories
          tagmaster.save
        end
      end
    end

    # Movieの削除処理
    tagmasters.each do |tagmaster|
      unless movie_tags.include?(tagmaster.name)
        categories = tagmaster.categories.split(",")
        if categories.length == 1 && tagmaster.categories.include?("movie")
          tagmaster.destroy
        elsif categories.length >= 2 && tagmaster.categories.include?("movie")
          categories.delete("movie")
          new_categories = ""
          isfirst = true
          categories.each do |category|
            if isfirst
              new_categories = category
              isfirst = false
            else
              new_categories = new_categories + "," + category
            end
          end
          tagmaster.categories = new_categories
          tagmaster.save
        end
      end
    end
    redirect_to :controller => "tags", :action => "index" and return
  end

  private
    def tag_params
      params.require(:tag).permit(:name, :movie_id, :value)
    end

end
