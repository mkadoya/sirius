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
		# [変更必要] タグ情報から、Userが選んだタグをselectする
		@array_choice_tag = ['しっとり', '感動']
		# tagを全てGetする
		@array_all_tag = Tag.all
		# tag nameを全てGetする
		@array_all_tag_name = Tag.pluck(:name).uniq
		# Movieのカラム情報を全て取得. htmlの簡素化のために
		@array_movie_columns = Movie.column_names
		@array_movie_columns << 'tag'
		# Userが選んだタグについての得点を合算してScoreが高い順にSortする. key=item_id, value=ユーザが選んだタグの合算
		@hash_score = Hash.new

		# Userが選んだタグごとにLoop処理
		@array_choice_tag.each do |tag|
			# 選んだTagがある映画のitem_idを取得. そのあと、さらにTag合致するため、tag情報を全て取得
			@array_all_tag =  @array_all_tag.where(item_id: @array_all_tag.where(name: tag).pluck(:item_id))
		end

		# 合致したitem_idごとにloop処理
		@array_all_tag.pluck(:item_id).uniq.each do |item_id|
			# 各種item_idと、@array_choice_tagのvalueを合算する
			@item_info = Movie.where(item_id: item_id).first.attributes
			@item_info.store("tag", Tag.where(item_id: item_id).pluck(:name))
			@hash_score.store(@item_info, Tag.where(item_id: item_id).where(name: @array_choice_tag).pluck(:value).sum)
		end
		# hashを昇順にSortする
		@hash_score = @hash_score.sort_by{ | k, v | v }.reverse

  end
end
