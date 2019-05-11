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

		# 結果の表示判定
		if (Result.where(user_id: @user_id).count > 0)
			@result_displayed = true
		end


		# アイテムを特定
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
		# 実行時間測定
		start_time = Time.now

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
		# ----------------------------------------------------------------------------------------------------------------



		# ------ 全アイテムの平均値、Recommendation 1stの平均値算出 -----------------------------------------------------------------------
		# アイテムのカラムを配列に入れる
		# @array_column_names = @actrec_all_item.column_names
		@array_column_names = ["price", "ssd", "cpu_score", "ram", "weight", "uptime", "gpu_score", "item_id", "windows", "inch"]
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
		@array_column_remove_star.each do |column|
			@hash_rec_star.delete(column)
			@hash_item_star.delete(column)
		end
		# 順位が小さい順にSort
		@hash_rec_star = Hash[@hash_rec_star.sort_by{ |_, v| -v }]
		@hash_item_star = Hash[@hash_item_star.sort_by{ |_, v| -v }]
		# ----------------------------------------------------------------------------------------------------------------

		# 実行時間測定
		@exec_time_rec = Time.now - start_time


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

# def show
# # User-id, category, Question_finishをquestion_controllerから引き受ける
# 	@user_id = cookies[:user_id].presence || 0
# 	@category = params[:category]
# 	@series = params[:series]
# 	@item_id = params[:item_id]
# 	@result_displayed = false
#
# 	# 結果の表示判定
# 	if (OptionResult.where(user_id: @user_id).count > 0)
# 		@result_displayed = true
# 	end
#
#
# 	# アイテムを特定
# 	if @category == "pc"
# 		@item = Pc.find_by(item_id: @item_id)
# 		@items = Pc.where(series: @series)
# 	elsif @category == "laptop"
# 		@item = Pc.find_by(item_id: @item_id)
# 		@items = Pc.where(series: @series)
# 	elsif @category == "desktop"
# 		@item = Pc.find_by(item_id: @item_id)
# 		@items = Pc.where(series: @series)
# 	elsif @category == "toiletpaper"
# 		@item = ToiletpaperItem.find_by(item_id: @item_id)
# 		@items = ToiletpaperItem.where(series: @series)
# 	else
# 		@item = Pc.find_by(item_id: @item_id)
# 		@items = Pc.where(series: @series)
# 	end
#
#
# 	# 人が定義しているParameterシリーズ
# 	# アイテム数を取得する
# 	if @category == "laptop"
# 		@item_display_num = Item.distinct.count(:series)
# 	else
# 		@item_display_num = ToiletpaperItem.distinct.count(:series)
# 	end
# 	#アイテムの表示数：偶数のみ可能
# 	# @item_display_num = 6
#
# 	#アイテムの表示行数
# 	@item_display_row_num = @item_display_num / 2 - 1
#
# 	# 推奨個数
# 	@num_recommend = 3
# 	# 評価の最高値
# 	@num_star_max = 10
# 	# 評価の最低値、実際は0だけど、あまりに低いとテンション下がるのでBaseライン
# 	@num_star_min = 3
# 	# 評価のための偏差値補正
# 	@num_std_mod = 3
#
#
#
# 	# 配列の初期化
# 	@array_option_id = Array.new
# 	@array_match_condition = Array.new
# 	@array_item = Array.new
# 	@array_item_series = Array.new
# 	@array_effective_column = Array.new
# 	@array_star = Array.new
# 	@array_star_normalize = Array.new
# 	@array_match_condition_test = Array.new
# 	@array_debug = Array.new
# 	# 辞書型の初期化
# 	@hash_difference_avrg = Hash.new
# 	@hash_rec_avrg = Hash.new
# 	@hash_rec_star = Hash.new
# 	@hash_star = Hash.new
#
# # ------ ここから、修正必要 by Takai -----------------------------------------------------------
# # ------ ここから、修正必要 by Takai -----------------------------------------------------------
# # ------ ここから、修正必要 by Takai -----------------------------------------------------------
# # ------ ここから、修正必要 by Takai -----------------------------------------------------------
# # ------ ここから、修正必要 by Takai -----------------------------------------------------------
# 	# いけていないかつ、Categoryが増えるごとにCodingしないといけないので変更必要。。。
# 	# remove from 優先順位 star
# 	@str_remove_star = ["emmc", "usb_c", "webcamera", "usb_a", "gpu_ram"]
# 	# 値が小さいほど良い項目List
# 	@column_asc_good = ["price", "weight"]
#
# 	# MatchさせていくためにItem情報を全部入れる
# 	if @category == "laptop"
# 		@array_recommend_item = Item.all
# 		@all_item = Item.all
# 	else
# 		@array_recommend_item = ToiletpaperItem.all
# 		@all_item = ToiletpaperItem.all
# 	end
#
# # ------ ここまで、修正必要 by Takai -----------------------------------------------------------
# # ------ ここまで、修正必要 by Takai -----------------------------------------------------------
# # ------ ここまで、修正必要 by Takai -----------------------------------------------------------
# # ------ ここまで、修正必要 by Takai -----------------------------------------------------------
# # ------ ここまで、修正必要 by Takai -----------------------------------------------------------
#
# 	# Totalのアイテム数
# 	@num_all_items = @all_item.all.count
# 	# Seriesの重複を除いたTotalのアイテム数
# 	@num_all_series = @all_item.select(:series).distinct.count
# 	# Userが選択した結果をuser-idとcategoryを指定してDBから抽出
# 	@array_record_true = OptionResult.where(user_id: @user_id).where(category: @category).where(result: true)
#
# 	# Userが答えてtrue flagがついたoption_idを配列で取得
# 	@array_record_true.each do |record_true|
# 		@array_option_id << record_true.option_id
# 		@array_debug << [Question.find_by(question_id: Option.find_by(option_id: record_true.option_id).question_id).content, Option.find_by(option_id: record_true.option_id).content]
# 	end
#
# 	# Userが答えてtrueがついたoption_idをBaseにItem DBでFilterする条件をMatch DBより配列で取得
# 	@array_option_id.each do |option_id|
# 		@array_match_condition << Match.where(category: @category).where(option_id: option_id)
# 	end
#
# 	# 最もEffectiveが高いもの(match条件にて合致する項目数が少ないもの)を計算
# 	@array_match_condition.each do |match_condition|
# 		match_condition.each do |record_match|
# 			@array_effective_column << [record_match.item_clmn, 1 - @all_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max).count.to_f/@num_all_items]
# 			@hash_difference_avrg.store(record_match.item_clmn, @all_item.average(:"#{record_match.item_clmn}").round(1))
# 			# @array_difference_avrg  << [record_match.item_clmn, Item.average(:record_match.item_clmn), @array_item.first(5).average(:record_match.item_clmn)]
# 		end
# 	end
#
# 	# おすすめ品がTotal個数ではなかったら。。Match DBから取得したFilter条件の末尾を削除して再度Item DBをFilter、おすすめ品が5つ以上になるまでloop
# 	while @array_item[@num_all_series - 1].nil?
#
# # ------ ここから、修正必要 by Takai -----------------------------------------------------------
# # ------ ここから、修正必要 by Takai -----------------------------------------------------------
# # ------ ここから、修正必要 by Takai -----------------------------------------------------------
# # ------ ここから、修正必要 by Takai -----------------------------------------------------------
# # ------ ここから、修正必要 by Takai -----------------------------------------------------------
# 		# MatchさせていくためにItem情報を全部入れる
# 		if @category == "laptop"
# 			@array_recommend_item = Item.all
# 		else
# 			@array_recommend_item = ToiletpaperItem.all
# 		end
# # ------ ここまで、修正必要 by Takai -----------------------------------------------------------
# # ------ ここまで、修正必要 by Takai -----------------------------------------------------------
# # ------ ここまで、修正必要 by Takai -----------------------------------------------------------
# # ------ ここまで、修正必要 by Takai -----------------------------------------------------------
# # ------ ここまで、修正必要 by Takai -----------------------------------------------------------
#
# 		# すでにおすすめされておすすめ品(@array_item)に格納されているSeriesをItem.allから削除
# 		@array_item_series.each do |item_series|
# 			@array_recommend_item = @array_recommend_item.where.not(series: item_series)
# 		end
#
# 		# Filterする条件を元にItem DBをFilter
# 		@array_match_condition.each do |match_condition|
# 			match_condition.each do |record_match|
# 				@array_recommend_item = @array_recommend_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max)
# 			end
# 		end
#
# 		# おすすめ品が空じゃなかったら処理、おすすめ品がからだったら条件削除に飛ぶ
# 		unless @array_recommend_item.empty?
# 			# おすすめ品をRank順にsort
# 			@array_recommend_item = @array_recommend_item.order(:price)
# 			# Series重複(Color重複)を削除したおすすめ品のSeies一覧を取得
# 			@array_recommend_item_distinct = @array_recommend_item.select(:series).distinct
# 			# Seiries一覧からおすすめItem一覧を取得
# 			@array_recommend_item_distinct.each do |recommend_item_distinct|
# 				# Series重複を省いたおすすめ品を結果に格納する
# 				@array_item << @all_item.find_by(series: recommend_item_distinct.series)
# 				@array_item_series << recommend_item_distinct.series
# 			end
# 		end
#
# 		# Match条件の末尾の条件を一つ削除
# 		@array_match_condition.pop
# 	end
#
#
# 	# Userが答えてtrueがついたoption_idをBaseにItem DBでFilterする条件をMatch DBより配列で取得
# 	@array_option_id.each do |option_id_test|
# 		@array_match_condition_test << Match.where(category: @category).where(option_id: option_id_test)
# 	end
#
# 	# 最もEffectiveが高いもの(match条件にて合致する項目数が少ないもの)を計算
# 	@array_match_condition_test.each do |match_condition_test|
# 		match_condition_test.each do |record_match_test|
# 			num = 0
# 			@array_item.first(@num_recommend).each do |item_test|
# 				if item_test[:"#{record_match_test.item_clmn}"] == true
# 					num_add = 1
# 				elsif item_test[:"#{record_match_test.item_clmn}"] == false
# 					num_add = 0
# 				else
# 					num_add = item_test[:"#{record_match_test.item_clmn}"]
# 				end
# 				num += num_add
# 			end
# 		@hash_rec_avrg.store(record_match_test.item_clmn, (num/@num_recommend.to_f).round(1))
# 		end
# 	end
#
# 	# Starのためのおすすめ品の平均値からのずれを算出
# 	@hash_rec_avrg.each do |key, value|
# 		if value != 0
# 			if @all_item.pluck(:"#{key}").first.is_a?(Numeric) == false
# 				@value_star = @all_item.pluck(:"#{key}").join(" ").gsub("false", "0").gsub("true", "1").split(" ").map(&:to_i)
# 			else
# 				@value_star = @all_item.pluck(:"#{key}")
# 			end
# 			@hash_star.store(key, (10 - (@value_star.sort.reverse.index{|i| i <= value} / @num_all_items.to_f * 10).round))
# 			# 基本項目をVectoyに入れる
# 			@df_default = Daru::Vector[@value_star]
# 			# 基本項目での推奨値を偏差値計算して中央値を5に変更、ただし4-7に固まって楽しくないので、偏差値は3倍の変動にしている
# 			ss = (((@hash_rec_avrg["#{key}"] - @df_default.mean )/@df_default.std * 10 * @num_std_mod + 50)/10).round
# 			# 項目によっては（例えば値段）、小さい値の方が良いのでその項目は10から偏差値をひいいて評価
# 			if @column_asc_good.include?(key) == true
# 				ss = @num_star_max - ss
# 			end
# 			# 偏差値にx2の補正を入れているので、over @num_star_max, under @num_star_maxになるものはlimitをかける
# 			if ss > @num_star_max
# 				ss = @num_star_max
# 			elsif ss < @num_star_min
# 				ss = @num_star_min
# 			end
# 			# 結果をHash（辞書型）に入れ込む
# 			@hash_rec_star.store(key, ss)
# 		end
# 	end
#
# 	# priceなどの特殊項目の削除
# 	@str_remove_star.each do |key|
# 		@hash_rec_star.delete(key)
# 		@hash_star.delete(key)
# 	end
#
# 	# 順位が小さい順にSort
# 	@hash_rec_star = Hash[@hash_rec_star.sort_by{ |_, v| -v }]
# 	@hash_star = Hash[@hash_star.sort_by{ |_, v| -v }]
#
# 	@item_counter = 0
#
# 	@items_array = Array.new
# 	@array_item.each do |item|
# 		@series_items = @all_item.where(series: item.series).all
# 		@series_items.each do |s_item|
# 			@items_array.push(s_item)
# 		end
# 	end
# end
# end
#
