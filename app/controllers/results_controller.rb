class ResultsController < ApplicationController
	def index
		# User-id, category, Question_finishをquestion_controllerから引き受ける
		@user_id = cookies[:user_id]
		@category = params[:category]
		@question_finish = params[:question_finish]

		# 実行時間測定
		start_time = Time.now

		# 記事のインポート
		@articles = Article.all

		# 人が定義しているParameterシリーズ
		# アイテム数を取得する
		# if @category == "pc"
		# 	@item_display_num = Pc.distinct.count(:series)
		# else
		# 	@item_display_num = ToiletpaperItem.distinct.count(:series)
		# end

		#アイテムの表示数：偶数のみ可能
		@item_display_num = 60
		#アイテムの表示行数
		@item_display_row_num = @item_display_num / 2 - 1

		# Star(評価)の最高値、最低値、標準偏差の補正値を定義
		@hash_condition_star = {:"integer_star_max" => 10, :"integer_star_min" => 3, :"integer_std_mod" => 3}

		# Debug用
		# [要削除] Production Releaseの際に、削除が必要
		@array_debug = Array.new

		# 配列の初期化
		@array_item = Array.new
		@array_item_2nd = Array.new
		@array_item_3rd = Array.new
		@array_item_id_1st = Array.new
		@array_item_id_2nd = Array.new
		@array_item_id_3rd = Array.new
		@array_item_series = Array.new
		@array_match_condition = Array.new
		@array_star = Array.new

		# 辞書型の初期化
		@hash_all_avrg = Hash.new
		@hash_rec_avrg = Hash.new
		@hash_all_star = Hash.new
		@hash_rec_star = Hash.new
		@hash_item_star = Hash.new
		@hash_column_array = Hash.new

		# remove from 優先順位 star
		# [要修正] Categoryが増えるたびに修正が必要なためイケていない.
		@array_column_remove_star = ["emmc", "usb_c", "webcamera", "usb_a", "item_id", "windows", "ram_max", "gamingpc", "ram_all_slot", "updated_at", "created_at", "date_sale", "cluster_sub", "cluster_main", "id", "series", "sirial", "shop_num", "quote", "os"]

		# 値が小さいほど良い項目List
		# [要修正] Categoryが増えるたびに修正が必要なためイケていない.
		@array_column_asc_good = ["price", "weight"]

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

# ------ Recommendation 1st : Filter条件から出す -----------------------------------------------------------------------
		# Userが選択した結果を元にoption_idを抽出
		@array_option_id = Result.where(user_id: @user_id).where(category: @category).where(result: true).pluck(:option_id)

		# Userが選択した結果のoption_idを元にMatch条件を抽出
		@array_option_id.each do |option_id|
			@array_match_condition << Match.where(category: @category).where(option_id: option_id)
			# Debug用
			# [要削除] Production Releaseの際に、削除が必要
			@array_debug << [Question.find_by(question_id: Option.find_by(option_id: option_id).question_id).content, Option.find_by(option_id: option_id).content]
		end

		# @actrec_recommend_itemに全アイテムを入れる
		@actrec_recommend_item = @actrec_all_item

		# Filterする条件を元におすすめ品をFilter
		@array_match_condition.each do |array_match|
			array_match.each do |record_match|
				# Recommendation 1stのActive Recordを作成
				@actrec_recommend_item = @actrec_recommend_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max)
			end
		end

		# おすすめ品が空だったらFilter条件を1つ削除して、再度Filterを実行
		while @actrec_recommend_item.empty?
			# Match条件の末尾の条件を一つ削除
			@array_match_condition.pop

			# Filterする条件を元におすすめ品をFilter
			@array_match_condition.each do |array_match|
				array_match.each do |record_match|
					# Recommendation 1stのActive Recordを作成
					@actrec_recommend_item = @actrec_all_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max)
				end
			end
		end

		# Recommendation 1stのItem idの配列を作成
		@array_item_id_1st = @actrec_recommend_item.pluck(:item_id).uniq.shuffle
# ----------------------------------------------------------------------------------------------------------------



# ------ Recommendation 2nd : Recommendation 1stと同じcluster_subから出す -----------------------------------------------------------------------
		# Recommendation 1stのitem_idの配列を全体から引いて、残りのitem_idの配列を作成
		@array_item_id_remain = @actrec_all_item.pluck(:item_id) - @array_item_id_1st

		# All itemからRecommendation 1stのitem_idを削除したActive Recordを取得
		@actrec_remain_item = @actrec_all_item.where(item_id: @array_item_id_remain)

		# Recommendation 1stのcluster_subを取得
		@array_rec_cluster_sub = @actrec_recommend_item.pluck(:cluster_sub).uniq

		# Recommendation 1stのcluster_subと同じclusterのitem_idを取得、.shuffleで順序をRandomに変える
		@array_item_2nd = @actrec_remain_item.where(cluster_sub: @array_rec_cluster_sub).pluck(:item_id).shuffle
# ----------------------------------------------------------------------------------------------------------------



# ------ Recommendation 3rd : Recommendation 1stと同じcluster_mainから出す -----------------------------------------------------------------------
		# Recommendation 2ndのitem_idの配列を@array_item_id_remainから引いて、残りのitem_idの配列を作成
		@array_item_id_remain = @array_item_id_remain - @array_item_2nd

		# All itemからRecommendation 1stのitem_idを削除したActive Recordを取得
		@actrec_remain_item = @actrec_all_item.where(item_id: @array_item_id_remain)

		# Recommendation 1stのcluster_mainを取得
		@array_rec_cluster_main = @actrec_recommend_item.pluck(:cluster_main).uniq

		# Recommendation 1stのcluster_subと同じclusterのitem_idを取得、.shuffleで順序をRandomに変える
		@array_item_3rd = @actrec_remain_item.where(cluster_main: @array_rec_cluster_main).pluck(:item_id).shuffle
# ----------------------------------------------------------------------------------------------------------------



# ------ Recommendation 残り : 残った商品をRandomで表示する -----------------------------------------------------------------------
		# Recommendation 3rdのitem_idの配列を@array_item_id_remainから引いて、残りのitem_idの配列を作成
		@array_item_id_remain = @array_item_id_remain - @array_item_3rd
		# 残りのitem_idの配列をuniqにしてRandomにする
		@array_item_id_remain = @array_item_id_remain.uniq.shuffle
# ----------------------------------------------------------------------------------------------------------------



# ------ Recommendation ALL : Recommendation Itemの配列を作る -----------------------------------------------------------------------
		# おすすめ順に並んだarray_itemを作る. 足し算の順序が重要なため注意
		@array_sorted_item = @array_item_id_1st + @array_item_2nd + @array_item_3rd + @array_item_id_remain

		# おすすめ品の情報が全て記載されているArrayを作成
		@array_sorted_item.each do |item_id|
			if @array_item_series.exclude?(@actrec_all_item.find_by(item_id: item_id).series)
				# おすすめ品情報をおすすめ順に@array_itemに格納する
				@array_item << @actrec_all_item.find_by(item_id: item_id)
				# @array_itemに加えたitemのseries情報を@array_item_seriesに格納
				@array_item_series << @actrec_all_item.find_by(item_id: item_id).series
			end
		end
# ----------------------------------------------------------------------------------------------------------------



# ------ 全アイテムの平均値、Recommendation 1stの平均値算出 -----------------------------------------------------------------------
		# アイテムのカラムを配列に入れる
		# @array_column_names = @actrec_all_item.column_names
		@array_column_names = ["price", "ssd", "cpu_score", "ram", "weight", "uptime", "gpu_score", "item_id", "windows", "inch"]
		# 全アイテムの各カラムごとの平均、おすすめ品の各カラムごとの平均を算出する
		@array_column_names.each do |column|
			# 全アイテムの平均値、Recommendation 1stの平均値の各カラムの有効数字を、商品のものに合わせる
			# 小数点が歩かないかチェック
			if @actrec_recommend_item.first["#{column}"].to_s.include?(".")
				effective_decimal = @actrec_recommend_item.first["#{column}"].to_s.split(".")[1].size
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
				integer_star = (((@hash_rec_avrg["#{column}"] - @df_default.mean )/@df_default.std * 10 * @hash_condition_star[:integer_std_mod] + 50)/10).round
				# 項目によっては（例えば値段）、小さい値の方が良いのでその項目は10から偏差値を引き算して評価
				if @array_column_asc_good.include?(column) == true
					integer_star = @hash_condition_star[:integer_star_max] - integer_star
				end
				# 偏差値に@hash_condition_star["integer_std_mod"]分の補正を入れているので、over @hash_condition_star["integer_star_max"], under @hash_condition_star["integer_star_min"]になるものはlimitをかける
				if integer_star > @hash_condition_star[:integer_star_max]
					integer_star = @hash_condition_star[:integer_star_max]
				elsif integer_star < @hash_condition_star[:integer_star_min]
					integer_star = @hash_condition_star[:integer_star_min]
				end
				# 結果をHashに入れ込む
				@hash_rec_star.store(column, integer_star)
			end
		end

		# 特殊項目の削除
		@array_column_remove_star.each do |column|
			@hash_rec_star.delete(column)
		end

		# 順位が小さい順にSort
		@hash_rec_star = Hash[@hash_rec_star.sort_by{ |_, v| -v }]
# ----------------------------------------------------------------------------------------------------------------

		# 実行時間測定
		@exec_time_rec = Time.now - start_time


# ------ Star計算 -----------------------------------------------------------------------
		# Starのためのおすすめ品の偏差値を算出. 偏差値が大きいもの順にSort. index.html.erbにてそのTop項目を重要項目として表示
		# item_idごとのstar計算
		# @array_sorted_item.each do |item_id|
		# 	# 各カラムごとにloop
		# 	@array_column_names.each do |column|
		# 		# 各カラムごとの全製品の値をDataframeに入れる
		# 		@df_default = Daru::Vector[@hash_column_array[:"#{column}"]]
		# 		integer_item = @actrec_all_item.find_by(item_id: item_id)["#{column}"]
		# 		unless integer_item.nil? || @df_default.std == 0 || integer_item.class == String
		# 			if integer_item = true
		# 				integer_item = 1
		# 			elsif integer_item = false
		# 				integer_item = 0
		# 			end
		# 			# 基本項目での推奨値を偏差値計算して中央値を5に変更、ただし4-7に固まって楽しくないので、偏差値は@hash_condition_star["integer_std_mod"]倍の補正をしている
		# 			integer_star = (((integer_item - @df_default.mean )/@df_default.std * 10 * @hash_condition_star[:integer_std_mod] + 50)/10).round
		# 			# 項目によっては（例えば値段）、小さい値の方が良いのでその項目は10から偏差値を引き算して評価
		# 			if @array_column_asc_good.include?(column) == true
		# 				integer_star = @hash_condition_star[:integer_star_max] - integer_star
		# 			end
		# 			# 偏差値に@hash_condition_star["integer_std_mod"]分の補正を入れているので、over @hash_condition_star["integer_star_max"], under @hash_condition_star["integer_star_min"]になるものはlimitをかける
		# 			if integer_star > @hash_condition_star[:integer_star_max]
		# 				integer_star = @hash_condition_star[:integer_star_max]
		# 			elsif integer_star < @hash_condition_star[:integer_star_min]
		# 				integer_star = @hash_condition_star[:integer_star_min]
		# 			end
		# 			# 各カラムごとの結果をHashに入れ込む
		# 			@hash_item_star.store(column, integer_star)
		# 		end
		# 	end
		# 	# 各item_idごとの結果をHashに入れ込む
		# 	@hash_all_star.store(item_id, @hash_item_star)
		# end
# ----------------------------------------------------------------------------------------------------------------

		@item_counter = 0

		# @items_array = Array.new
		# @array_item.each do |item|
		# 	@series_items = @actrec_all_item.where(series: item.series).all
		# 	@series_items.each do |s_item|
		# 		@items_array.push(s_item)
		# 	end
		# end

		# 実行時間測定
		@exec_time = Time.now - start_time
	end
end
