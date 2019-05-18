class ItemsController < ApplicationController
	def show
		# User-id, category, Question_finishをquestion_controllerから引き受ける
		@user_id = cookies[:user_id].presence || 0
		@category = params[:category]
		@series = params[:series]
		@item_id = params[:item_id]
		@result_displayed = false

		# 結果の表示判定
    if (Result.where(user_id: @user_id).count > 0)
      @result_displayed = true
    end


		# アイテムを特定
		# [要修正] Categoryが増えるたびに修正が必要なためイケていない.
		if @category == "pc"
			@item = Pc.find_by(item_id: @item_id)
			@items = Pc.where(series: @series)
		elsif @category == "laptop"
			@item = Pc.find_by(item_id: @item_id)
			@items = Pc.where(series: @series)
		elsif @category == "desktop"
			@item = Pc.find_by(item_id: @item_id)
			@items = Pc.where(series: @series)
		elsif @category == "toiletpaper"
			@item = ToiletpaperItem.find_by(item_id: @item_id)
			@items = ToiletpaperItem.where(series: @series)
		else
			@item = Pc.find_by(item_id: @item_id)
			@items = Pc.where(series: @series)
		end

		# Star(評価)の最高値、最低値、標準偏差の補正値を定義
		@hash_condition_star = {:"integer_star_max" => 10, :"integer_star_min" => 3, :"integer_std_mod" => 3}

		# filterで引っかからなかった時に、clusterごとに評価する、その時recoomend 1stとして表示させる上位clusterのParcentage
		@num_recommend_percentage = 20

		# あなたにとって重要な項目数
		@num_recommend = 5

		# remove from 優先順位 star
		# [要修正] Categoryが増えるたびに修正が必要なためイケていない.
		# @array_column_remove_star = ["emmc", "usb_c", "webcamera", "usb_a", "item_id", "windows", "ram_max", "gamingpc", "ram_all_slot", "updated_at", "created_at", "date_sale", "cluster_sub", "cluster_main", "id", "series", "sirial", "shop_num", "quote", "os"]

		# 値が小さいほど良い項目List
		# [要修正] Categoryが増えるたびに修正が必要なためイケていない.
		# @array_column_asc_good = ["price", "weight"]

		# 各Category別にItem情報を全部入れる.
		# [要修正] Categoryが増えるたびに修正が必要なためイケていない.
		if @category == "pc"
			@actrec_all_item = Pc.all
		elsif @category == "laptop"
			@actrec_all_item = Pc.where(category: @category)
		elsif @category == "desktop"
			@actrec_all_item = Pc.where(category: @category)
		elsif @category == "toiletpaper"
			@actrec_all_item = ToiletpaperItem.all
		else
			@actrec_all_item = Pc.all
		end


# ------ 今後使う配列、辞書型を初期化 -----------------------------------------------------------------------
		# 配列の初期化
		@array_match_condition = Array.new
		@array_string_cluster_column_sort = Array.new

		# 辞書型の初期化
		@hash_all_avrg = Hash.new
		@hash_rec_avrg = Hash.new
		@hash_rec_star = Hash.new
		@hash_item_star = Hash.new
		@hash_column_array = Hash.new
		@hash_column = Hash.new
		@hash_string_cluster_column = Hash.new
		@hash_tmp_avrg = Hash.new
		@hash_score = Hash.new
		@hash_column = Hash.new

		# Debug用
		# [要削除] Production Releaseの際に、削除が必要
		@array_debug = Array.new

# ----------------------------------------------------------------------------------------------------------------


# ------ Viewのための前準備 -----------------------------------------------------------------------
		# 各Categoryにおける基本項目を取得
		@array_fundamental = Column.where(category: @category).where(fundamental: true).pluck(:column_name)
		# 各Categoryにおける基本項目数を取得
		@num_fundamental = @array_fundamental.count
		# Recommendに含めるためのアイテムのカラム情報をActive Recordで取得
		@actrec_column_info = Column.where(category: @category).where(remove: false)
		# Recommendに含めるためのアイテムのカラムを配列に入れる
		@array_column_names = @actrec_column_info.pluck(:column_name)
		# 値が小さいほど良い項目List
		@array_column_asc_good = Column.where(category: @category).where(dsc_better: true).pluck(:column_name)
		# User Frendlyな表示のためのカラム取得
		Column.where(category: @category).each do |column|
			@hash_column.store(column.column_name, {"frendly_name"=>column.frendly_name, "unit"=>column.unit})
		end

		# 基本情報の項目
		@array_item_info = Column.where(category: @category).where(item_info: true).pluck(:column_name)
		# 基本情報の項目数
		@integer_item_info_count = @array_item_info.count
		# あり、なし項目のカラム一覧
		@array_na_column = Column.where(category: @category).where(available: true).pluck(:column_name)
# ----------------------------------------------------------------------------------------------------------------



# ------ Recommendation 1st : Filter条件から出す -----------------------------------------------------------------------
		# 対象のItemのclusterのccolumn数をカウント
		@array_string_cluster_column = @actrec_all_item.column_names.grep(/cluster_.*/)

		# 一番細かいcluster順にsortするために、各clusterの分類数をカウントする
		@array_string_cluster_column.each do |cluster_column_name|
			@hash_string_cluster_column.store("#{cluster_column_name}", @actrec_all_item.pluck(:"#{cluster_column_name}").uniq.count)
		end

		# 各clusterの分類数が多い順にclusterのcolumn name arrayを作る
		@hash_string_cluster_column.sort{|(k1, v1), (k2, v2)| v2 <=> v1}.to_h.each_key do |key|
			@array_string_cluster_column_sort << key
		end

		# Userが選択した結果を元にoption_idを抽出
		@array_option_id = Result.where(user_id: @user_id).where(category: @category).where(result: true).pluck(:option_id)

		# Userが選択した結果のoption_idを元にMatch条件を抽出
		@array_match_condition = Match.where(category: @category).where(option_id: @array_option_id)

		# Debug用
		# [要削除] Production Releaseの際に、削除が必要
		@array_option_id.each do |option_id|
			@array_debug << [Question.find_by(question_id: Option.find_by(option_id: option_id).question_id).content, Option.find_by(option_id: option_id).content]
		end

		# @actrec_recommend_itemに全アイテムを入れる
		@actrec_recommend_item = @actrec_all_item

		# Filterする条件を元におすすめ品をFilter
		@array_match_condition.each do |record_match|
			# Recommendation 1stのActive Recordを作成
			@actrec_recommend_item = @actrec_recommend_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max)
		end

# ----------------------------------------------------------------------------------------------------------------



# ------ Recommendation 1st : Filter条件から出せなかった時 -----------------------------------------------------------------------
		# おすすめ品が空だったらClusterごとに得点をつけて計算
		if @actrec_recommend_item.empty?

			# 一番細分化されたClusterのID数を取得
			@integer_cluster_count = @actrec_all_item.pluck(:"#{@array_string_cluster_column_sort.first}").uniq.count
			# 採点用のScoreを作成. FibocacciでScoreをつける
			# 通常、Fibocacci数列は、[0, 1, 1, 2, 3, 5, 8, 13 ,...]だけど、1, 1と連続させたくないので、削除するために1, 2からにしている
			# @array_fibonacci = [1, 2]
			# for i in 2..@integer_cluster_count
			# 	tmp = @array_fibonacci[i - 1] + @array_fibonacci[i - 2]
			# 	@array_fibonacci << tmp
			# end

			@array_fibonacci = [*1..@integer_cluster_count]

			# 値が大きい順にSort
			@array_fibonacci.reverse!

			# 一番細分化されたClusterのID一覧を取得
			@array_cluster = @actrec_all_item.pluck(:"#{@array_string_cluster_column_sort.first}").uniq
			# Match条件でFilterしているカラムを抽出
			@array_filter_column = Match.where(category: @category).where(option_id: @array_option_id).pluck(:item_clmn).uniq
			@array_filter_column.delete("item_id")


			# 各Filterをかけるカラムごとに採点
			@array_filter_column.each do |column|
				# 一番細分化されたClusterのID一覧ごとに採点
				@array_cluster.each do |cluster|
					# columnのcluster_idごとの平均値を取得
					num_average = Pc.where("#{@array_string_cluster_column_sort.first}": "#{cluster}").average(:"#{column}")
					# もし平均値がnilじゃなかったら、hashにその値を入れる
					if num_average.nil? == false
						@hash_tmp_avrg.store("#{cluster}", @actrec_all_item.where("#{@array_string_cluster_column_sort.first}": "#{cluster}").average(:"#{column}"))
					end
				end

				# 項目によっては（例えば値段）、小さい値の方が良いので、それ用にsort
				if @array_column_asc_good.include?(column)
					# 値が小さい順にsortさせる
					@hash_tmp_avrg = @hash_tmp_avrg.sort{|(key1, value1), (key2, value2)| value1 <=> value2}.to_h
				else
					# 値が大きい順にsortさせる
					@hash_tmp_avrg = @hash_tmp_avrg.sort{|(key1, value1), (key2, value2)| value2 <=> value1}.to_h
				end

				# 各カラムの値が大きい順に得点をつけたいので、rankごとにfibonacci数列に依存する得点をつける
				num_rank = 0
				# Sortされた各カラムを大きい順にkeyでloopさせる
				@hash_tmp_avrg.each_key do |key|
					# もし、keyがnilなら、fibonacciによるランキングの値をそのまま入れる
					if @hash_score[key].nil?
						@hash_score.store("#{key}", @array_fibonacci[num_rank])
					# nilじゃないなら、既存の値にランキングづけした値を足し算をする
					else
						@hash_score.store("#{key}", @hash_score["#{key}"] + @array_fibonacci[num_rank])
					end
					num_rank += 1
				end
			end

			# 各カラムの得点が大きい順にkey(cluster_id)をsortする
			@hash_score = @hash_score.sort{|(key1, value1), (key2, value2)| value2 <=> value1}.to_h
			@num_recommend_cluster = (@num_recommend_percentage / 100.0 * @hash_score.keys.count).round
			@actrec_recommend_item = @actrec_all_item.where("#{@array_string_cluster_column_sort.first}": @hash_score.keys.first(@num_recommend_cluster))
		end
# ----------------------------------------------------------------------------------------------------------------


# ------ 全アイテムの平均値、Recommendation 1stの平均値算出 -----------------------------------------------------------------------
		# 全アイテムの各カラムごとの平均、おすすめ品の各カラムごとの平均を算出する
		@array_column_names.each do |column|
			# 小数点が歩かないかチェック
			if @item["#{column}"].to_s.include?(".")
				effective_decimal = @item["#{column}"].to_s.split(".")[1].size
				# 全アイテムの各カラムごとの平均
				@hash_all_avrg.store(column, @actrec_all_item.average(:"#{column}").round(effective_decimal))
				# Recommendation 1stの各カラムごとの平均
				@hash_rec_avrg.store(column, @actrec_recommend_item.average(:"#{column}").round(effective_decimal))
			else
				effective_decimal = 0
				# 全アイテムの各カラムごとの平均
				@hash_all_avrg.store(column, @actrec_all_item.average(:"#{column}").round(effective_decimal).to_i)
				# Recommendation 1stの各カラムごとの平均
				@hash_rec_avrg.store(column, @actrec_recommend_item.average(:"#{column}").round(effective_decimal).to_i)
			end

			# Daru:Vectoryに入れるために、各カラムごとの前処理. 1:True, Falseを0, 1に変換. 2:nil削除.
			if @actrec_all_item.pluck(:"#{column}").compact.first.is_a?(Numeric) == false
				array_column_value = @actrec_all_item.pluck(:"#{column}").join(" ").gsub("false", "0").gsub("true", "1").split(" ").map(&:to_i).compact
			else
				array_column_value = @actrec_all_item.pluck(:"#{column}").compact
			end
			# Hashに入れる
			@hash_column_array.store("#{column}", array_column_value)
		end
# ----------------------------------------------------------------------------------------------------------------



# ------ Star計算 -----------------------------------------------------------------------
		# Starのためのおすすめ品の偏差値を算出. 偏差値が大きいもの順にSort. index.html.erbにてそのTop項目を重要項目として表示
		@array_column_names.each do |column|

			# 各カラムごとの全製品の値をDataframeに入れる
			@df_default = Daru::Vector[@hash_column_array["#{column}"]]
			unless @hash_rec_avrg["#{column}"].nil? || @df_default.std == 0
				# 基本項目での推奨値を偏差値計算して中央値を5に変更、ただし4-7に固まって楽しくないので、偏差値は@hash_condition_star["integer_std_mod"]倍の補正をしている
				@integer_star = (((@hash_rec_avrg["#{column}"] - @df_default.mean )/@df_default.std * 10 * @hash_condition_star[:integer_std_mod] + 50)/10).round
				# 項目によっては（例えば値段）、小さい値の方が良いのでその項目は10から偏差値を引き算して評価
				if @array_column_asc_good.include?(column) == true
					@integer_star = @hash_condition_star[:integer_star_max] - @integer_star
				end
				# 偏差値に@hash_condition_star["integer_std_mod"]分の補正を入れているので、over @hash_condition_star["integer_star_max"], under @hash_condition_star["integer_star_min"]になるものはlimitをかける
				if @integer_star > @hash_condition_star[:integer_star_max]
					@integer_star = @hash_condition_star[:integer_star_max]
				elsif @integer_star < @hash_condition_star[:integer_star_min]
					@integer_star = @hash_condition_star[:integer_star_min]
				end
				# 結果をHashに入れ込む
				@hash_rec_star.store(column, @integer_star)
			end
		end

# ------ Star計算 -----------------------------------------------------------------------
		# Starのためのおすすめ品の偏差値を算出. 偏差値が大きいもの順にSort. index.html.erbにてそのTop項目を重要項目として表示
		# 各カラムごとにloop
		@array_column_names.each do |column|
			# 各カラムごとの全製品の値をDataframeに入れる
			@df_default = Daru::Vector[@hash_column_array["#{column}"]]
			@integer_item = @item["#{column}"]
			unless @integer_item.nil? || @df_default.std == 0 || @integer_item.class == String
				if @integer_item == true
					@integer_item = 1
				elsif @integer_item == false
					@integer_item = 0
				end
				# 基本項目での推奨値を偏差値計算して中央値を5に変更、ただし4-7に固まって楽しくないので、偏差値は@hash_condition_star["integer_std_mod"]倍の補正をしている
				@integer_star = (((@integer_item - @df_default.mean )/@df_default.std * 10 * @hash_condition_star[:integer_std_mod] + 50)/10).round
				# 項目によっては（例えば値段）、小さい値の方が良いのでその項目は10から偏差値を引き算して評価
				if @array_column_asc_good.include?(column) == true
					@integer_star = @hash_condition_star[:integer_star_max] - @integer_star
				end
				# 偏差値に@hash_condition_star["integer_std_mod"]分の補正を入れているので、over @hash_condition_star["integer_star_max"], under @hash_condition_star["integer_star_min"]になるものはlimitをかける
				if @integer_star > @hash_condition_star[:integer_star_max]
					@integer_star = @hash_condition_star[:integer_star_max]
				elsif @integer_star < @hash_condition_star[:integer_star_min]
					@integer_star = @hash_condition_star[:integer_star_min]
				end
				# 各カラムごとの結果をHashに入れ込む
				@hash_item_star.store(column, @integer_star)
			end
		end
# ----------------------------------------------------------------------------------------------------------------

		# 特殊項目の削除
		# @array_column_remove_star.each do |column|
		# 	@hash_rec_star.delete(column)
		# 	@hash_item_star.delete(column)
		# end

		# 順位が小さい順にSort
		@hash_rec_star = Hash[@hash_rec_star.sort_by{ |_, v| -v }]
		@hash_item_star = Hash[@hash_item_star.sort_by{ |_, v| -v }]
# ----------------------------------------------------------------------------------------------------------------

	end
end
