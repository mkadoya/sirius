class OptionResultsController < ApplicationController
  def result
    @user_id = params[:user_id]
    @category = params[:category]
    @user_id = 3
    # Question idを重複なしで、昇順で取り出します
    @arr_question_id = Question.pluck(:question_id).uniq.sort

    # Pattern DB内で使われているcolumnを取り出します
    @arr_answer_id = Pattern.column_names.uniq

    # 質問と回答一覧取得のために、空の配列を作成
    @arr_question = Array.new
    @arr_answer = Array.new

    # 配列 Loop
    @arr_question_id.each{|q_id|
    	@arr_question << Question.find_by(question_id:q_id).content
    	@arr_answer << Result.order(updated_at: "DESC").find_by(user_id:@user_id, question_id:q_id).answer
    }

    # 質問の答えから、合致するpattern_idの列を取得。今は、質問数12問固定。。そのうち可変に対応できるようにします
    @pattern_pattern_id = Pattern.find_by(answer_1: @arr_answer[0], answer_2: @arr_answer[1], answer_3: @arr_answer[2], answer_4: @arr_answer[3], answer_5: @arr_answer[4], answer_6: @arr_answer[5], answer_7: @arr_answer[6], answer_8: @arr_answer[7], answer_9: @arr_answer[8], answer_10: @arr_answer[9], answer_11: @arr_answer[10],  answer_12: @arr_answer[11])

    # 合致しない場合のnil(NULL)対策。。
    if @pattern_pattern_id.nil?
    	@pattern_pattern_id = Characteristic.first
    end

    # 質問の答えから、合致するpattern_idの列を取得。今は、質問数12問固定。。そのうち可変に対応できるようにします
    @pattern_pattern_id = @pattern_pattern_id.pattern_id

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

    # Itemからアイテム情報を格納
    @item_1 = Item.find_by(item_id: @charasteristic_item_1)
    @item_2 = Item.find_by(item_id: @charasteristic_item_2)
    @item_3 = Item.find_by(item_id: @charasteristic_item_3)
    @item_4 = Item.find_by(item_id: @charasteristic_item_4)
    @item_5 = Item.find_by(item_id: @charasteristic_item_5)


  end

  def create
    # 各パラメーターの導入
    @category         = params[:category] ? params[:category] : "laptop"
    @question_id      = params[:question_id] ? params[:question_id].to_i : nil
    @question_num     = params[:question_num] ? params[:question_num].to_i : nil
    @next_question_id = params[:next_question_id] ? params[:next_question_id].to_i : nil
    @selected_option_id  = params[:option_id] ? params[:option_id].to_i : nil
    @user_id          = params[:user_id]

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
      redirect_to :controller => "questions", :action => "option_index", :user_id => @user_id, :category => @category, :next_question_id => @next_question_id, :question_num => @question_num and return
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
    redirect_to :controller => "questions", :action => "option_index", :user_id => @user_id, :category => @category, :next_question_id => @next_question_id, :question_num => @question_num
  end

end
