class ResultsController < ApplicationController
	def index
		@user_id = cookies[:user_id]
		@category = params[:category]

		#アイテムの表示数：偶数のみ可能
		@item_display_num = 6

		#アイテムの表示行数
		@item_display_row_num = @item_display_num / 2 - 1

		# 配列の初期化 : Debug用
		@debug_array = Array.new

		# 推奨個数
		@num_recommend = 3
		# remove from 優先順位 star
		@str_remove_star = ["emmc", "usb_c", "webcamera", "usb_a", "gpu_ram"]
		# 値が小さいほど良い項目List
		@column_asc_good = ["price", "weight"]

		# 配列の初期化
		@array_option_id = Array.new
		@array_match_condition = Array.new
		@array_item = Array.new
		@array_item_series = Array.new
		@array_effective_column = Array.new
		@array_star = Array.new
		@array_star_normalize = Array.new
		@array_match_condition_test = Array.new
		# 辞書型の初期化
		@hash_difference_avrg = Hash.new
		@hash_rec_avrg = Hash.new
		@hash_rec_star = Hash.new
		@hash_star = Hash.new

		# MatchさせていくためにItem情報を全部入れる
		@array_recommend_item = Item.all
		@all_item =  Item.all
		# Totalのアイテム数
		@num_all_items = @all_item.all.count
		# Seriesの重複を除いたTotalのアイテム数
		@num_all_series = @all_item.select(:series).distinct.count
		# Userが選択した結果をuser-idとcategoryを指定してDBから抽出
		@array_record_true = OptionResult.where(user_id: @user_id).where(category: @category).where(result: true)

		# Userが答えてtrue flagがついたoption_idを配列で取得
		@array_record_true.each do |record_true|
			@array_option_id << record_true.option_id
			@debug_array << [Question.find_by(question_id: Option.find_by(option_id: record_true.option_id).question_id).content, Option.find_by(option_id: record_true.option_id).content]
		end

		# Userが答えてtrueがついたoption_idをBaseにItem DBでFilterする条件をMatch DBより配列で取得
		@array_option_id.each do |option_id|
			@array_match_condition << Match.where(category: @category).where(option_id: option_id)
		end

		# 最もEffectiveが高いもの(match条件にて合致する項目数が少ないもの)を計算
		@array_match_condition.each do |match_condition|
			match_condition.each do |record_match|
				@array_effective_column << [record_match.item_clmn, 1 - @all_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max).count.to_f/@num_all_items]
				@hash_difference_avrg.store(record_match.item_clmn, @all_item.average(:"#{record_match.item_clmn}").round(1))
				# @array_difference_avrg  << [record_match.item_clmn, Item.average(:record_match.item_clmn), @array_item.first(5).average(:record_match.item_clmn)]
			end
		end

		# 最もEffectiveが高いもの(match条件にて合致する項目数が少ないもの)をSortして昇順で5つ取得
		# @array_effective_column = @array_effective_column.reject{|clmn, val| clmn == @str_remove_star}.uniq!(&:first).sort { |a, b| b[1] <=> a[1] }.first(5)

		# Star設定
		# @array_effective_column.each do |colmn, val|
		# 	@array_star << val
		# end
		# @star_max = @array_star.max
		# @star_min = @array_star.min
		# @array_star.each do |val|
		# 	@array_star_normalize << ((val - @star_min)/(@star_max - @star_min) * 6).ceil + 3
		# end

		# おすすめ品がTotal個数ではなかったら。。Match DBから取得したFilter条件の末尾を削除して再度Item DBをFilter、おすすめ品が5つ以上になるまでloop
		while @array_item[@num_all_series - 1].nil?

			# 全Itemを格納
			@array_recommend_item = Item.all

			# すでにおすすめされておすすめ品(@array_item)に格納されているSeriesをItem.allから削除
			@array_item_series.each do |item_series|
				@array_recommend_item = @array_recommend_item.where.not(series: item_series)
			end

			# Filterする条件を元にItem DBをFilter
			@array_match_condition.each do |match_condition|
				match_condition.each do |record_match|
					@array_recommend_item = @array_recommend_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max)
				end
			end

			# おすすめ品が空じゃなかったら処理、おすすめ品がからだったら条件削除に飛ぶ
			unless @array_recommend_item.empty?
				# おすすめ品をRank順にsort
				@array_recommend_item = @array_recommend_item.order(:price)
				# Series重複(Color重複)を削除したおすすめ品のSeies一覧を取得
				@array_recommend_item_distinct = @array_recommend_item.select(:series).distinct
				# Seiries一覧からおすすめItem一覧を取得
				@array_recommend_item_distinct.each do |recommend_item_distinct|
					# Series重複を省いたおすすめ品を結果に格納する
					@array_item << @all_item.find_by(series: recommend_item_distinct.series)
					@array_item_series << recommend_item_distinct.series
				end
			end

			# Match条件の末尾の条件を一つ削除
			@array_match_condition.pop
		end


		# Userが答えてtrueがついたoption_idをBaseにItem DBでFilterする条件をMatch DBより配列で取得
		@array_option_id.each do |option_id_test|
			@array_match_condition_test << Match.where(category: @category).where(option_id: option_id_test)
		end

		# 最もEffectiveが高いもの(match条件にて合致する項目数が少ないもの)を計算
		@array_match_condition_test.each do |match_condition_test|
			match_condition_test.each do |record_match_test|
				num = 0
				@array_item.first(@num_recommend).each do |item_test|
					if item_test[:"#{record_match_test.item_clmn}"] == true
						num_add = 1
					elsif item_test[:"#{record_match_test.item_clmn}"] == false
						num_add = 0
					else
						num_add = item_test[:"#{record_match_test.item_clmn}"]
					end
					num += num_add
				end
			@hash_rec_avrg.store(record_match_test.item_clmn, (num/@num_recommend.to_f).round(1))
			end
		end

		# Starのためのおすすめ品の平均値からのずれを算出
		@hash_rec_avrg.each do |key, value|
			if value != 0
				if @all_item.pluck(:"#{key}").first.is_a?(Numeric) == false
					@value_star = @all_item.pluck(:"#{key}").join(" ").gsub("false", "0").gsub("true", "1").split(" ").map(&:to_i)
				else
					@value_star = @all_item.pluck(:"#{key}")
				end
				@hash_star.store(key, (10 - (@value_star.sort.reverse.index{|i| i <= value} / @num_all_items.to_f * 10).round))
				# 基本項目をVectoyに入れる
				@df_default = Daru::Vector[@value_star]
				# 基本項目での推奨値を偏差値計算して中央値を5に変更、ただし4-7に固まって楽しくないので、偏差値は3倍の変動にしている
				ss = (((@hash_rec_avrg["#{key}"] - @df_default.mean )/@df_default.std * 30 + 50)/10).round
				# 項目によっては（例えば値段）、小さい値の方が良いのでその項目は10から偏差値をひいいて評価
				if @column_asc_good.include?(key) == true
					ss = 10 - ss
				end
				# 偏差値にx2の補正を入れているので、over 10, under 0になるものはlimitをかける
				if ss > 10
					ss = 10
				elsif ss < 1
					ss = 1
				end
				# 結果をHash（辞書型）に入れ込む
				@hash_rec_star.store(key, ss)
			end
		end

		# priceなどの特殊項目の削除
		@str_remove_star.each do |key|
			@hash_rec_star.delete(key)
			@hash_star.delete(key)
		end

		# 順位が小さい順にSort
		@hash_rec_star = Hash[@hash_rec_star.sort_by{ |_, v| -v }]
		@hash_star = Hash[@hash_star.sort_by{ |_, v| -v }]

# ------ 以下、大幅Update必要 ! ----------------------------------------------------------------------------
    # 質問の答えから、合致するpattern_idの列を取得。今は、質問数12問固定。。そのうち可変に対応できるようにします
    @pattern_pattern_id = 1

    # Pattern取得
    @characteristic = Characteristic.find_by(category: @category, pattern_id: @pattern_pattern_id)

    # Patternから属性情報の取得
    @charasteristic_title = @characteristic.title
    @charasteristic_body = @characteristic.body
    @charasteristic_chara_1_str = @characteristic.chara_1_str
    @charasteristic_chara_2_str = @characteristic.chara_2_str
    @charasteristic_chara_3_str = @characteristic.chara_3_str
    @charasteristic_chara_4_str = @characteristic.chara_4_str
    @charasteristic_chara_5_str = @characteristic.chara_5_str
    @charasteristic_chara_1_val = @characteristic.chara_1_val
    @charasteristic_chara_2_val = @characteristic.chara_2_val
    @charasteristic_chara_3_val = @characteristic.chara_3_val
    @charasteristic_chara_4_val = @characteristic.chara_4_val
    @charasteristic_chara_5_val = @characteristic.chara_5_val
    @charasteristic_item_1 = @characteristic.item_1
    @charasteristic_item_2 = @characteristic.item_2
    @charasteristic_item_3 = @characteristic.item_3
    @charasteristic_item_4 = @characteristic.item_4
    @charasteristic_item_5 = @characteristic.item_5
# ------ 以上、大幅Update必要 ! ----------------------------------------------------------------------------
		@item_counter = 0

		@items_array = Array.new
		@array_item.each do |item|
			@series_items = @all_item.where(series: item.series).all
			@series_items.each do |s_item|
				@items_array.push(s_item)
			end
		end
	end


	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------

	def index2
		# 配列の初期化 : Debug用
		@debug_array = Array.new
		# 手動で入れているけど、questionから引き継がれる : Debug用
		@user_id = 1
		# categoryは今後めっちゃくちゃ増えます！！！！ : Debug用
		@category = "laptop"
		# おすすめスペックとして算出する上記おすすめ品項目
		@num_recommend = 10
		# remove from 優先順位 star
		@str_remove_star = ["emmc", "usb_c", "webcamera", "usb_a", "gpu_ram"]
		# 値が小さいほど良い項目List
		@column_asc_good = ["price", "weight"]

		# 配列の初期化
		@array_option_id = Array.new
		@array_match_condition = Array.new
		@array_item = Array.new
		@array_item_series = Array.new
		@array_effective_column = Array.new
		@array_star = Array.new
		@array_star_normalize = Array.new
		@array_match_condition_test = Array.new
		# 辞書型の初期化
		@hash_difference_avrg = Hash.new
		@hash_rec_avrg = Hash.new
		@hash_rec_star = Hash.new
		@hash_star = Hash.new

		# MatchさせていくためにItem情報を全部入れる
		@array_recommend_item = Item.all
		# Totalのアイテム数
		@num_all_items = Item.all.count
		# Seriesの重複を除いたTotalのアイテム数
		@num_all_series = Item.select(:series).distinct.count
		# Userが選択した結果をuser-idとcategoryを指定してDBから抽出
		@array_record_true = OptionResult.where(user_id: @user_id).where(category: @category).where(result: true)

		# Userが答えてtrue flagがついたoption_idを配列で取得
		@array_record_true.each do |record_true|
			@array_option_id << record_true.option_id
			@debug_array << [Question.find_by(question_id: Option.find_by(option_id: record_true.option_id).question_id).content, Option.find_by(option_id: record_true.option_id).content]
		end

		# Userが答えてtrueがついたoption_idをBaseにItem DBでFilterする条件をMatch DBより配列で取得
		@array_option_id.each do |option_id|
			@array_match_condition << Match.where(category: @category).where(option_id: option_id)
		end

		# 最もEffectiveが高いもの(match条件にて合致する項目数が少ないもの)を計算
		@array_match_condition.each do |match_condition|
			match_condition.each do |record_match|
				@array_effective_column << [record_match.item_clmn, 1 - Item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max).count.to_f/@num_all_items]
				@hash_difference_avrg.store(record_match.item_clmn, Item.average(:"#{record_match.item_clmn}").round(1))
				# @array_difference_avrg  << [record_match.item_clmn, Item.average(:record_match.item_clmn), @array_item.first(5).average(:record_match.item_clmn)]
			end
		end

		# 最もEffectiveが高いもの(match条件にて合致する項目数が少ないもの)をSortして昇順で5つ取得
		# @array_effective_column = @array_effective_column.reject{|clmn, val| clmn == @str_remove_star}.uniq!(&:first).sort { |a, b| b[1] <=> a[1] }.first(5)

		# Star設定
		# @array_effective_column.each do |colmn, val|
		# 	@array_star << val
		# end
		# @star_max = @array_star.max
		# @star_min = @array_star.min
		# @array_star.each do |val|
		# 	@array_star_normalize << ((val - @star_min)/(@star_max - @star_min) * 6).ceil + 3
		# end

		# おすすめ品がTotal個数ではなかったら。。Match DBから取得したFilter条件の末尾を削除して再度Item DBをFilter、おすすめ品が5つ以上になるまでloop
		while @array_item[@num_all_series - 1].nil?

			# 全Itemを格納
			@array_recommend_item = Item.all

			# すでにおすすめされておすすめ品(@array_item)に格納されているSeriesをItem.allから削除
			@array_item_series.each do |item_series|
				@array_recommend_item = @array_recommend_item.where.not(series: item_series)
			end

			# Filterする条件を元にItem DBをFilter
			@array_match_condition.each do |match_condition|
				match_condition.each do |record_match|
					@array_recommend_item = @array_recommend_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max)
				end
			end

			# おすすめ品が空じゃなかったら処理、おすすめ品がからだったら条件削除に飛ぶ
			unless @array_recommend_item.empty?
				# おすすめ品をRank順にsort
				@array_recommend_item = @array_recommend_item.order(:price)
				# Series重複(Color重複)を削除したおすすめ品のSeies一覧を取得
				@array_recommend_item_distinct = @array_recommend_item.select(:series).distinct
				# Seiries一覧からおすすめItem一覧を取得
				@array_recommend_item_distinct.each do |recommend_item_distinct|
					# Series重複を省いたおすすめ品を結果に格納する
					@array_item << Item.find_by(series: recommend_item_distinct.series)
					@array_item_series << recommend_item_distinct.series
				end
			end

			# Match条件の末尾の条件を一つ削除
			@array_match_condition.pop
		end


		# Userが答えてtrueがついたoption_idをBaseにItem DBでFilterする条件をMatch DBより配列で取得
		@array_option_id.each do |option_id_test|
			@array_match_condition_test << Match.where(category: @category).where(option_id: option_id_test)
		end

		# 最もEffectiveが高いもの(match条件にて合致する項目数が少ないもの)を計算
		@array_match_condition_test.each do |match_condition_test|
			match_condition_test.each do |record_match_test|
				num = 0
				@array_item.first(@num_recommend).each do |item_test|
					if item_test[:"#{record_match_test.item_clmn}"] == true
						num_add = 1
					elsif item_test[:"#{record_match_test.item_clmn}"] == false
						num_add = 0
					else
						num_add = item_test[:"#{record_match_test.item_clmn}"]
					end
					num += num_add
				end
			@hash_rec_avrg.store(record_match_test.item_clmn, (num/@num_recommend.to_f).round(1))
			end
		end

		# Starのためのおすすめ品の平均値からのずれを算出
		@hash_rec_avrg.each do |key, value|
			if value != 0
				if Item.pluck(:"#{key}").first.is_a?(Numeric) == false
					@value_star = Item.pluck(:"#{key}").join(" ").gsub("false", "0").gsub("true", "1").split(" ").map(&:to_i)
				else
					@value_star = Item.pluck(:"#{key}")
				end
				@hash_star.store(key, (10 - (@value_star.sort.reverse.index{|i| i <= value} / @num_all_items.to_f * 10).round))
				# 基本項目をVectoyに入れる
				@df_default = Daru::Vector[@value_star]
				# 基本項目での推奨値を偏差値計算して中央値を5に変更、ただし4-7に固まって楽しくないので、偏差値は2倍の変動にしている
				ss = (((@hash_rec_avrg["#{key}"] - @df_default.mean )/@df_default.std * 20 + 50)/10).round
				# 項目によっては（例えば値段）、小さい値の方が良いのでその項目は10から偏差値をひいいて評価
				if @column_asc_good.include?(key) == true
					ss = 10 - ss
				end
				# 偏差値にx2の補正を入れているので、over 10, under 0になるものはlimitをかける
				if ss > 10
					ss = 10
				elsif ss < 0
					ss = 0
				end
				# 結果をHash（辞書型）に入れ込む
				@hash_rec_star.store(key, ss)
			end
		end

		# priceなどの特殊項目の削除
		@str_remove_star.each do |key|
			@hash_rec_star.delete(key)
			@hash_star.delete(key)
		end

		# 順位が小さい順にSort
		@hash_rec_star = Hash[@hash_rec_star.sort_by{ |_, v| -v }]
		@hash_star = Hash[@hash_star.sort_by{ |_, v| -v }]

	end

	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------

	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------

	def index3
		# 配列の初期化 : Debug用
		@debug_array = Array.new
		# 手動で入れているけど、questionから引き継がれる : Debug用
		@user_id = cookies[:user_id]
		# categoryは今後めっちゃくちゃ増えます！！！！ : Debug用
		@category = "toiletpaper"
		# おすすめスペックとして算出する上記おすすめ品項目
		@num_recommend = 2
		# remove from 優先順位 star
		@str_remove_star = ["emmc", "usb_c", "webcamera"]
		# 値が小さいほど良い項目List
		@column_asc_good = ["price", "weight"]

		# 配列の初期化
		@array_option_id = Array.new
		@array_match_condition = Array.new
		@array_item = Array.new
		@array_item_series = Array.new
		@array_effective_column = Array.new
		@array_star = Array.new
		@array_star_normalize = Array.new
		@array_match_condition_test = Array.new
		# 辞書型の初期化
		@hash_difference_avrg = Hash.new
		@hash_rec_avrg = Hash.new
		@hash_rec_star = Hash.new
		@hash_star = Hash.new

		# MatchさせていくためにItem情報を全部入れる
		@array_recommend_item = ToiletpaperItem.all
		# Totalのアイテム数
		@num_all_items = ToiletpaperItem.all.count
		# Seriesの重複を除いたTotalのアイテム数
		@num_all_series = ToiletpaperItem.select(:series).distinct.count
		# Userが選択した結果をuser-idとcategoryを指定してDBから抽出
		@array_record_true = OptionResult.where(user_id: @user_id).where(category: @category).where(result: true)

		# Userが答えてtrue flagがついたoption_idを配列で取得
		@array_record_true.each do |record_true|
			@array_option_id << record_true.option_id
			@debug_array << [Question.find_by(question_id: Option.find_by(option_id: record_true.option_id).question_id).content, Option.find_by(option_id: record_true.option_id).content]
		end

		# Userが答えてtrueがついたoption_idをBaseにItem DBでFilterする条件をMatch DBより配列で取得
		@array_option_id.each do |option_id|
			@array_match_condition << Match.where(category: @category).where(option_id: option_id)
		end

		# 最もEffectiveが高いもの(match条件にて合致する項目数が少ないもの)を計算
		@array_match_condition.each do |match_condition|
			match_condition.each do |record_match|
				@array_effective_column << [record_match.item_clmn, 1 - ToiletpaperItem.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max).count.to_f/@num_all_items]
				@hash_difference_avrg.store(record_match.item_clmn, ToiletpaperItem.average(:"#{record_match.item_clmn}").round(1))
				# @array_difference_avrg  << [record_match.item_clmn, Item.average(:record_match.item_clmn), @array_item.first(5).average(:record_match.item_clmn)]
			end
		end

		# 最もEffectiveが高いもの(match条件にて合致する項目数が少ないもの)をSortして昇順で5つ取得
		# @array_effective_column = @array_effective_column.reject{|clmn, val| clmn == @str_remove_star}.uniq!(&:first).sort { |a, b| b[1] <=> a[1] }.first(5)

		# Star設定
		# @array_effective_column.each do |colmn, val|
		# 	@array_star << val
		# end
		# @star_max = @array_star.max
		# @star_min = @array_star.min
		# @array_star.each do |val|
		# 	@array_star_normalize << ((val - @star_min)/(@star_max - @star_min) * 6).ceil + 3
		# end

		# おすすめ品がTotal個数ではなかったら。。Match DBから取得したFilter条件の末尾を削除して再度Item DBをFilter、おすすめ品が5つ以上になるまでloop
		while @array_item[@num_all_series - 1].nil?

			# 全Itemを格納
			@array_recommend_item = ToiletpaperItem.all

			# すでにおすすめされておすすめ品(@array_item)に格納されているSeriesをItem.allから削除
			@array_item_series.each do |item_series|
				@array_recommend_item = @array_recommend_item.where.not(series: item_series)
			end

			# Filterする条件を元にItem DBをFilter
			@array_match_condition.each do |match_condition|
				match_condition.each do |record_match|
					@array_recommend_item = @array_recommend_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max)
				end
			end

			# おすすめ品が空じゃなかったら処理、おすすめ品がからだったら条件削除に飛ぶ
			unless @array_recommend_item.empty?
				# おすすめ品をRank順にsort
				@array_recommend_item = @array_recommend_item.order(:price)
				# Series重複(Color重複)を削除したおすすめ品のSeies一覧を取得
				@array_recommend_item_distinct = @array_recommend_item.select(:series).distinct
				# Seiries一覧からおすすめItem一覧を取得
				@array_recommend_item_distinct.each do |recommend_item_distinct|
					# Series重複を省いたおすすめ品を結果に格納する
					@array_item << ToiletpaperItem.find_by(series: recommend_item_distinct.series)
					@array_item_series << recommend_item_distinct.series
				end
			end

			# Match条件の末尾の条件を一つ削除
			@array_match_condition.pop
		end


		# Userが答えてtrueがついたoption_idをBaseにItem DBでFilterする条件をMatch DBより配列で取得
		@array_option_id.each do |option_id_test|
			@array_match_condition_test << Match.where(category: @category).where(option_id: option_id_test)
		end

		# 最もEffectiveが高いもの(match条件にて合致する項目数が少ないもの)を計算
		@array_match_condition_test.each do |match_condition_test|
			match_condition_test.each do |record_match_test|
				num = 0
				@array_item.first(@num_recommend).each do |item_test|
					if item_test[:"#{record_match_test.item_clmn}"] == true
						num_add = 1
					elsif item_test[:"#{record_match_test.item_clmn}"] == false
						num_add = 0
					else
						num_add = item_test[:"#{record_match_test.item_clmn}"]
					end
					num += num_add
				end
			@hash_rec_avrg.store(record_match_test.item_clmn, (num/@num_recommend.to_f).round(1))
			end
		end

		# Starのためのおすすめ品の平均値からのずれを算出
		@hash_rec_avrg.each do |key, value|
			if value != 0
				if ToiletpaperItem.pluck(:"#{key}").first.is_a?(Numeric) == false
					@value_star = ToiletpaperItem.pluck(:"#{key}").join(" ").gsub("false", "0").gsub("true", "1").split(" ").map(&:to_i)
				else
					@value_star = ToiletpaperItem.pluck(:"#{key}")
				end
				@hash_star.store(key, (10 - (@value_star.sort.reverse.index{|i| i <= value} / @num_all_items.to_f * 10).round))
				# 基本項目をVectoyに入れる
				@df_default = Daru::Vector[@value_star]
				# 基本項目での推奨値を偏差値計算して中央値を5に変更、ただし4-7に固まって楽しくないので、偏差値は2倍の変動にしている
				ss = (((@hash_rec_avrg["#{key}"] - @df_default.mean )/@df_default.std * 20 + 50)/10).round
				# 項目によっては（例えば値段）、小さい値の方が良いのでその項目は10から偏差値をひいいて評価
				if @column_asc_good.include?(key) == true
					ss = 10 - ss
				end
				# 偏差値にx2の補正を入れているので、over 10, under 0になるものはlimitをかける
				if ss > 10
					ss = 10
				elsif ss < 0
					ss = 0
				end
				# 結果をHash（辞書型）に入れ込む
				@hash_rec_star.store(key, ss)
			end
		end

		# priceなどの特殊項目の削除
		@str_remove_star.each do |key|
			@hash_rec_star.delete(key)
			@hash_star.delete(key)
		end

		# 順位が小さい順にSort
		@hash_rec_star = Hash[@hash_rec_star.sort_by{ |_, v| -v }]
		@hash_star = Hash[@hash_star.sort_by{ |_, v| -v }]

	end

	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------
	# ------ Debug by Takai ---------------------------------------------------------------------------------

	def create
	# 各パラメーターの導入
    @category         = params[:category] ? params[:category] : "laptop"
    @user_id          = params[:user_id] ? params[:user_id].to_i : nil
    @question_id      = params[:question_id] ? params[:question_id].to_i : nil
    @question_num     = params[:question_num] ? params[:question_num].to_i : nil
    @next_question_id     = params[:next_question_id] ? params[:next_question_id].to_i : nil
    @selected_option_id        = params[:option_id] ? params[:option_id].to_i : nil

    # オプション一覧の取得
    @options =  Option.where(question_id: @question_id).all

    # 結果が存在しているか確認し、存在している場合はアップデートする
    # アップデート後は質問ページへリダイレクトする
    @results = OptionResult.where(user_id: @user_id).where(question_id: @question_id).all
    if @results.count > 0
      @results.each do |result|
        if @selected_option_id  == result.option_id
          result.result = true
          result.save
        else
          result.result = false
          result.save
        end
	  end

	  redirect_to :controller => "questions", :action => "index", :user_id => @user_id, :category => @category, :next_question_id => @next_question_id, :question_num => @question_num and return
	  	# 20190324　アップデート前
    	#redirect_to :controller => "questions", :action => "option_index", :user_id => @user_id, :category => @category, :next_question_id => @next_question_id, :question_num => @question_num and return
    end

    # 結果の作成
    # オプションとして選択されたID以外はFALSEで格納する
    @options.each do |option|
      if @selected_option_id  == option.option_id
        @result = true
      else
        @result = false
      end

      @option_result = OptionResult.create(
        user_id: @user_id,
        option_id: option.option_id,
        category: @category,
        question_id: @question_id,
        result: @result
        )
      @option_result.save
    end

    # 質問ページへリダイレクトする
    redirect_to :controller => "questions", :action => "index", :user_id => @user_id, :category => @category, :next_question_id => @next_question_id, :question_num => @question_num

		# 20190324 アップデート前
		# #answer/question_id結果を格納
		# @answers = params[:answers]
		# @question_ids = params[:question_ids]
		# @category = params[:category]

		# #ResultDBの中でユーザーIDが一番古いものを取得
		# @result = Result.order(updated_at: "DESC").first

		# #ユーザーIDが存在しなかったら「1」。存在したらインクリメントしたユーザーIDを指定
		# if @result.nil?
		# 	@user_id = 1
		# else
		# 	@user_id = @result.user_id.to_i + 1
		# end

		# #データベースへ書き込み
		# @question_num = 0

		# @answers.each do |answer|
		# 	@question_id = @question_ids[@question_num].to_i
		# 	@result = Result.create(user_id: @user_id, question_id: @question_id, answer:answer)
		# 	@result.save
		# 	@question_num += 1
		# end

		# #index2へリダイレクト
		# redirect_to :controller => "results", :action => "index2", :user_id => @user_id, :category => @category
	end
end
