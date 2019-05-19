class ResultsController < ApplicationController
	def index
		# Debug用
		# [要削除]実行時間測定
		start_time = Time.now

		# User-id, category, Question_finishをquestion_controllerから引き受ける
		@user_id = cookies[:user_id]
		@category = params[:category]
		@before_question_id_array = cookies[:before_questions].presence || 0

		# @question_finish = params[:question_finish]

		# 記事のインポート
		@articles = Article.all

		# Star(評価)の最高値、最低値、標準偏差の補正値を定義
		@hash_condition_star = {:"integer_star_max" => 10, :"integer_star_min" => 3, :"integer_std_mod" => 3}

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
		@array_match_condition = Array.new

		# 辞書型の初期化
		@hash_all_avrg = Hash.new
		@hash_rec_avrg = Hash.new
		@hash_all_star = Hash.new
		@hash_rec_star = Hash.new
		@hash_item_star = Hash.new
		@hash_column_array = Hash.new

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
		@array_sorted_item = @actrec_recommend_item.order(price: "ASC").pluck(:item_id).uniq
# ----------------------------------------------------------------------------------------------------------------

		# 実行時間測定
		@exec_time_filter = Time.now - start_time



# ------ Recommendation by cluster : Recommendation 1stと同じclusterから出す -----------------------------------------------------------------------
		# 対象のItemのclusterのcolumn数をカウント
		@array_string_cluster_column = @actrec_all_item.column_names.grep(/cluster_.*/).reverse

		# clusterのcolumn数分だけ同一ClusterによるRecommend挿入を実施
		@array_string_cluster_column.each do |cluster_column|
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

	def new
		@user_id = params[:user_id]
		@category = params[:category]
		@selectedOptions = params[:selectedOptions].split(",")
		beforeQuestions = params[:beforeQuestions]
		if beforeQuestions.length > 0
			beforeQuestions = params[:beforeQuestions] + "," + @category
		end
		cookies.permanent[:before_questions] = { :value => beforeQuestions }
		@times = 1
		if (Result.where(user_id: @user_id ).all.count != 0)
			@times = Result.where(user_id: @user_id ).order(times: "DESC").first.times + 1
		end

		@selectedOptions.each do |option|
			result = Result.where(option_id:option).where(times:(@times-1)).first
			unless result.nil?
				result.destroy
				result.save
			end
			result = Result.create(
            user_id: @user_id,
            option_id: option,
            category: @category,
            question_id: Option.find_by(option_id: option).question_id,
			result: true,
			times: @times,
			)
			result.save
		end

		redirect_to :controller => "results", :action => "index", :category => @category and return

	end

end
