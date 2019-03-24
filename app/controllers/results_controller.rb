class ResultsController < ApplicationController
  def index
		# 手動で入れているけど、questionから引き継がれる
		@user_id = 3
		# categoryは今後めっちゃくちゃ増えます！！！！
		@category = 'laptop'
		# Recommendアイテム数
		@num_recommend_item = 5
		# Sub-Recommendアイテム数. 'Sub-Recommend'は、result/index.htmlにおいて表示するやー
		@num_sub_recommend_item = 15

		# Userが選択した結果をuser-idとcategoryを指定してDBから抽出
		@array_record_true = OptionResult.where(user_id: @user_id).where(category: @category).where(result: true)

		# 配列の初期化
		@array_option_id = Array.new
		@array_match_condition = Array.new
		@array_item = Array.new
		@array_item_display = Array.new

		# MatchさせていくためにItem情報を全部入れる
		@array_recommend_item = Item.all

		# Userが答えてtrue flagがついたoption_idを配列で取得
		@array_record_true.each do |record_true|
			@array_option_id << record_true.option_id
		end

		# Userが答えてtrue flagがついたoption_idをBaseにItem DBでFilterする条件をMatch DBより配列で取得
		@array_option_id.each do |option_id|
			@array_match_condition << Match.where(category: @category).where(option_id: option_id)
		end

		# Filterする条件を元にItem DBをFilter
		@array_match_condition.each do |match_condition|
			match_condition.each do |record_match|
				@array_recommend_item = @array_recommend_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max)
			end
		end

		# おすすめ品をRack順にsort
		@array_recommend_item = @array_recommend_item.order(:rank)

		# Series重複(Color重複)を削除したおすすめ品のSeies一覧を取得
		@array_recommend_item_distinct = @array_recommend_item.select(:series).distinct

		# Seiries一覧からおすすめItem一覧を取得
		@array_recommend_item_distinct.each do |recommend_item_distinct|
			@array_item << Item.find_by(series: recommend_item_distinct.series)
		end




		# おすすめ品が5個なかったら。。Match DBから取得したFilter条件の末尾を削除して再度Item DBをFilter、おすすめ品が5つ以上になるまでloop
		while @array_item[@num_recommend_item + @num_sub_recommend_item - 1].nil?
			@array_recommend_item = Item.all
			@array_match_condition.pop
			@array_match_condition.each do |match_condition|
				match_condition.each do |record_match|
					@array_recommend_item = @array_recommend_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max)
				end
			end
			# おすすめ品をRack順にsort
			@array_recommend_item = @array_recommend_item.order(:rank)
			# Series重複(Color重複)を削除したおすすめ品のSeies一覧を取得
			@array_recommend_item_distinct = @array_recommend_item.select(:series).distinct
			# Seiries一覧からおすすめItem一覧を取得
			@array_recommend_item_distinct.each do |recommend_item_distinct|
				@array_item << Item.find_by(series: recommend_item_distinct.series)
			end
		end

		@item_1 = @array_item[0]
		@item_2 = @array_item[1]
		@item_3 = @array_item[2]
		@item_4 = @array_item[3]
		@item_5 = @array_item[4]


  end





  def index2
		# 手動で入れているけど、questionから引き継がれる
		# @user_id = 10
		@user_id = params[:user_id]

		# categoryは今後めっちゃくちゃ増えます！！！！
		@category = params[:category]

		# Recommendアイテム数
		@num_recommend_item = 5

		# Userが選択した結果をuser-idとcategoryを指定してDBから抽出
		@array_record_true = OptionResult.where(user_id: @user_id).where(category: @category).where(result: true)

		# 配列の初期化
		@array_option_id = Array.new
		@array_match_condition = Array.new

		# MatchさせていくためにItem情報を全部入れる
		@array_recommend_item = Item.all

		# Userが答えてtrue flagがついたoption_idを配列で取得
		@array_record_true.each do |record_true|
			@array_option_id << record_true.option_id
		end

		# Userが答えてtrue flagがついたoption_idをBaseにItem DBでFilterする条件をMatch DBより配列で取得
		@array_option_id.each do |option_id|
			@array_match_condition << Match.where(category: @category).where(option_id: option_id)
		end

		# Filterする条件を元にItem DBをFilter
		@array_match_condition.each do |match_condition|
			match_condition.each do |record_match|
				@array_recommend_item = @array_recommend_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max)
			end
		end

		# おすすめ品が5つなかったら。。Match DBから取得したFilter条件の末尾を削除して再度Item DBをFilter、おすすめ品が5つ以上になるまでloop
		while @array_recommend_item[@num_recommend_item - 1].nil?
			@array_recommend_item = Item.all
			@array_match_condition.pop
			@array_match_condition.each do |match_condition|
				match_condition.each do |record_match|
					@array_recommend_item = @array_recommend_item.where("#{record_match.item_clmn} >= ?", record_match.min).where("#{record_match.item_clmn} <= ?", record_match.max)
				end
			end
		end

		# おすすめ品をRack順にsort
		@array_recommend_item = @array_recommend_item.order(:rank)
		# Itemからアイテム情報を格納
		@item_1 = @array_recommend_item[0]
		@item_2 = @array_recommend_item[1]
		@item_3 = @array_recommend_item[2]
		@item_4 = @array_recommend_item[3]
		@item_5 = @array_recommend_item[4]

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
  end




  def create
		#answer/question_id結果を格納
		@answers = params[:answers]
		@question_ids = params[:question_ids]
		@category = params[:category]

		#ResultDBの中でユーザーIDが一番古いものを取得
		@result = Result.order(updated_at: "DESC").first

		#ユーザーIDが存在しなかったら「1」。存在したらインクリメントしたユーザーIDを指定
		if @result.nil?
			@user_id = 1
		else
			@user_id = @result.user_id.to_i + 1
		end

		#データベースへ書き込み
		@question_num = 0

		@answers.each do |answer|
			@question_id = @question_ids[@question_num].to_i
			@result = Result.create(user_id: @user_id, question_id: @question_id, answer:answer)
			@result.save
			@question_num += 1
		end

		#index2へリダイレクト
		redirect_to :controller => "results", :action => "index2", :user_id => @user_id, :category => @category
  end
end
