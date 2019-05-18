class ResultsController < ApplicationController
	def index
		# Debug用
		# [要削除]実行時間測定
		start_time = Time.now

		# User-id, category, Question_finishをquestion_controllerから引き受ける
		@user_id = cookies[:user_id]
		@category = params[:category]
		@question_finish = params[:question_finish]

		# 記事のインポート
		@articles = Article.all

		# Star(評価)の最高値、最低値、標準偏差の補正値を定義
		@hash_condition_star = {:"integer_star_max" => 10, :"integer_star_min" => 3, :"integer_std_mod" => 3}

		# filterで引っかからなかった時に、clusterごとに評価する、その時recoomend 1stとして表示させる上位clusterのParcentage
		@num_recommend_percentage = 20

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

		#アイテムの表示数：偶数のみ可能
		@item_display_num = @actrec_all_item.pluck(:series).uniq.count / 2

		# Debug用
		# [要削除] Production Releaseの際に、削除が必要
		@array_debug = Array.new

		# 配列の初期化
		@array_item = Array.new
		@array_item_series = Array.new
		@array_filter_column = Array.new
		@array_string_cluster_column_sort = Array.new

		# 辞書型の初期化
		@hash_all_avrg = Hash.new
		@hash_rec_avrg = Hash.new
		@hash_all_star = Hash.new
		@hash_rec_star = Hash.new
		@hash_item_star = Hash.new
		@hash_column_array = Hash.new
		@hash_string_cluster_column = Hash.new
		@hash_cluster_score = Hash.new
		@hash_tmp_avrg = Hash.new
		@hash_score = Hash.new


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

# ------ Recommendation 1stを価格順にSort -----------------------------------------------------------------------
		# Recommendation 1stのItem idの配列を作成
		@array_sorted_item = @actrec_recommend_item.order(price: "ASC").pluck(:item_id).uniq
# ----------------------------------------------------------------------------------------------------------------

		# 実行時間測定
		@exec_time_filter = Time.now - start_time

# ------ Recommendation by cluster : Recommendation 1stと同じclusterから出す -----------------------------------------------------------------------
		# clusterのcolumn数分だけ同一ClusterによるRecommend挿入を実施
		@array_string_cluster_column_sort.each do |cluster_column|
			# array_sorted_itemのitem_idの配列を全体から引いて、残りのitem_idの配列を作成
			@array_item_id_remain = @actrec_all_item.pluck(:item_id) - @array_sorted_item
			# All itemからarray_sorted_itemのitem_idを削除したActive Recordを取得
			@actrec_remain_item = @actrec_all_item.where(item_id: @array_item_id_remain)
			# Recommendation 1stのclusterを取得
			@array_rec_cluster_add = @actrec_recommend_item.pluck(:"#{cluster_column}").uniq
			# Recommendation 1stのclusterと同じclusterのitem_idを取得、.shuffleで順序をRandomに変える
			@array_item_add = @actrec_remain_item.where("#{cluster_column}": @array_rec_cluster_add).pluck(:item_id).shuffle
			# Recommendation 1stのおすすめ品ListにClusterによるおすすめ品をくっつける
			@array_sorted_item.concat(@array_item_add)
		end


		# Recommendation 残り : 残った商品をRandomで表示する
		# array_sorted_itemのitem_idの配列を@array_item_id_remainから引いて、残りのitem_idの配列を作成
		@array_item_id_remain = @actrec_all_item.pluck(:item_id) - @array_sorted_item
		# 残りのitem_idの配列をuniqにしてRandomにする
		@array_item_add = @array_item_id_remain.uniq.shuffle
		# おすすめ順に並んだarray_itemを作る
		@array_sorted_item.concat(@array_item_add)
# ----------------------------------------------------------------------------------------------------------------

		# 実行時間測定
		@exec_time_check = Time.now - start_time


# ------ Recommendation ALL : Recommendation Itemの配列を作る -----------------------------------------------------------------------
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

		# 実行時間測定
		@exec_time_cluster = Time.now - start_time

# ------ 全アイテムの平均値、Recommendation 1stの平均値算出 -----------------------------------------------------------------------
		# アイテムのカラムを配列に入れる
		# @array_column_names = @actrec_all_item.column_names
		@array_column_names = ["price", "ssd", "cpu_score", "ram", "weight", "uptime", "gpu_score", "item_id", "windows", "inch"]
		# 全アイテムの各カラムごとの平均、おすすめ品の各カラムごとの平均を算出する
		@array_column_names.each do |column|
			# 全アイテムの平均値、Recommendation 1stの平均値の各カラムの有効数字を、商品のものに合わせる
			# nil check
			if @actrec_recommend_item.average(:"#{column}").nil? == false
				# 小数点があるかチェック
				if @actrec_recommend_item.first["#{column}"].to_s.include?(".")
					# 小数点があるカラムである場合には、小数点の第何位まであるのかをeffective_decimalに入れる
					effective_decimal = @actrec_recommend_item.first["#{column}"].to_s.split(".")[1].size
					# 全アイテムの各カラムごとの平均
					@hash_all_avrg.store(column, @actrec_all_item.average(:"#{column}").round(effective_decimal))
					# Recommendation 1stの各カラムごとの平均
					@hash_rec_avrg.store(column, @actrec_recommend_item.average(:"#{column}").round(effective_decimal))
				else
					# 小数点があるカラムである場合には、effective_decimalとして0を入れる
					effective_decimal = 0
					# 全アイテムの各カラムごとの平均
					@hash_all_avrg.store(column, @actrec_all_item.average(:"#{column}").round(effective_decimal).to_i)
					# Recommendation 1stの各カラムごとの平均
					@hash_rec_avrg.store(column, @actrec_recommend_item.average(:"#{column}").round(effective_decimal).to_i)
				end
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

		# 実行時間測定
		@exec_time_avrg = Time.now - start_time

# ------ Star計算 -----------------------------------------------------------------------
		# Starのためのおすすめ品の偏差値を算出. 偏差値が大きいもの順にSort. index.html.erbにてそのTop項目を重要項目として表示
		@array_column_names.each do |column|

			# 各カラムごとの全製品の値をDataframeに入れる
			@df_default = Daru::Vector[@hash_column_array["#{column}"]]
			unless @hash_rec_avrg["#{column}"].nil? || @df_default.std == 0
				# 基本項目での推奨値を偏差値計算して中央値を5に変更、ただし4-7に固まって楽しくないので、偏差値は@hash_condition_star["integer_std_mod"]倍の補正をしている
				integer_star = (((@hash_rec_avrg["#{column}"] - @df_default.mean )/@df_default.std * 10 * @hash_condition_star[:integer_std_mod] + 50)/10).round
				# 項目によっては（例えば値段）、小さい値の方が良いのでその項目は10から偏差値を引き算して評価
				if @array_column_asc_good.include?(column)
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
		@exec_time = Time.now - start_time
	end
end
