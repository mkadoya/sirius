class QuestionsController < ApplicationController
  def index
    # カテゴリーのフレンドリーネーム
    @category_firendly_name = "パソコン"

    # 各パラメーターの導入
    @category         = params[:category] ? params[:category] : "laptop"
    @question_num     = params[:question_num] ? params[:question_num].to_i : nil
    @next_question_id = params[:next_question_id] ? params[:next_question_id].to_i : nil
    @user_id          = cookies[:user_id].presence || 0
    @start_question_id = Question.find_by(category: @category).question_id
    @option_id = params[:option_id].presence || 0
    @result_displayed = false

    # 記事のインポート
    @articles = Article.all

    # Cookie情報がない場合、新規ユーザーを作成する。
    if @user_id == 0

			# 最初のユーザの場合には、@new_user_idとして1を設定
      if TempUser.first.nil? == true
        @new_user_id = 1
			# 2番以降のUserは、既存のUser-idの一番大き奴に1足したIDにする
      else
        @new_user_id = TempUser.order(user_id: "DESC").first.user_id + 1
      end
      @new_user_name = "Guest"
      @user = TempUser.create(user_id: @new_user_id, name:@new_user_name)
      @user.save
      cookies.permanent[:user_id] = { :value => @new_user_id }
      redirect_to :controller => "questions", :action => "index", :category => @category and return
    end

  # 選択されたOptionが存在している場合はデータベースに書き込む
    if (@option_id != 0)
      @selected_option = Option.where(option_id: @option_id).first
      selected_question = @selected_option.question_id.to_i
      # 選択されたオプションに紐づくQuestionに紐づくオプション一覧の取得
      all_options =  Option.where(question_id: selected_question).all
      # 結果が存在しているか確認し、存在している場合はアップデートする
      @results = Result.where(user_id: @user_id).where(question_id: selected_question).all
      if @results.count > 0
        @results.each do |result|
          if @selected_option.option_id  == result.option_id
            result.result = true
            result.save
          else
            result.result = false
            result.save
          end
        end
      else
        all_options.each do |option|
          if @selected_option.option_id  == option.option_id
            @result = true
          else
            @result = false
          end
          @option_result = Result.create(
            user_id: @user_id,
            option_id: option.option_id,
            category: @category,
            question_id: selected_question,
            result: @result
          )
          @option_result.save
        end
      end
    end

    # 結果の表示判定
    if (Result.where(user_id: @user_id).count > 0)
      @result_displayed = true
    end

    # 質問数が存在しない場合は、１に設定する
    # 質問数が存在している場合は、１インクリメントする
    if !@question_num
      @question_num = 1
    else
      @question_num += 1
    end

    # 次の質問がない場合（最後の質問だった場合）、リザルト画面を表示する
    if @next_question_id==0
      @max_question_num = @question_num - 1
      return
    end

    # 次の質問が存在しない場合は、ID：１の質問を導入する
    # 次の質問が存在している場合は、そのIDの問題を導入する
    if !@next_question_id
      @question = Question.find_by(question_id: @start_question_id)
    else
      @question = Question.find_by(question_id: @next_question_id)
    end

    # 最大質問数
    @max_question_num = @question_num + @question.remain_question_num

    # 選択肢を取得する
    @options = Option.where(question_id: @question.question_id).all

    # 1問目でなければ前回の質問IDを導入する
    if  @question.question_id != @start_question_id
      # range = Range.new(1, @question_num-1)
      range = Range.new(1, @question_num - 1)
      range.each do |num|
        if num==1
          option_id = Result.find_by(user_id:@user_id, question_id:@start_question_id, result:true).option_id
          @n_question_id = Option.find_by(option_id:option_id).next_question_id
          @before_question_id = Option.find_by(option_id:option_id).question_id
        else
          option_id = Result.find_by(user_id:@user_id, question_id:@n_question_id, result:true).option_id
          @n_question_id = Option.find_by(option_id:option_id).next_question_id
          @before_question_id = Option.find_by(option_id:option_id).question_id
        end
      end
    end
  end

  def category
    # 各パラメーターの導入
    @category         = params[:category] ? params[:category] : "laptop"
    @category_name    = Category.find_by(category: @category).name
    @user_id          = cookies[:user_id].presence || 0
    @start_question_id = Question.find_by(category: @category).question_id
    @result_displayed = false
    @categories = {}

    # 記事のインポート
    @articles = Article.all

    # 結果の表示判定
    if (Result.where(user_id: @user_id).count > 0)
      @result_displayed = true
      category_array = Result.where(user_id:@user_id).pluck(:category).uniq
      category_array.each do |category|
        name = Category.find_by(category: category).name
        @categories[category] = name
      end
    end

    # 各種配列
    @question_id_array = Array.new
    @question_content_array = Array.new
    @question_remain_array = Array.new
    @option_id_array = Array.new
    @option_question_id_array = Array.new
    @option_next_question_id_array = Array.new
    @option_content_array = Array.new
    @before_question_id_array = Array.new

    # Cookie情報がない場合、新規ユーザーを作成する。
    if @user_id == 0
			# 最初のユーザの場合には、@new_user_idとして1を設定
      if TempUser.first.nil? == true
        @user_id = 1
			# 2番以降のUserは、既存のUser-idの一番大きい数図に１プラスしたIDにする
      else
        @user_id = TempUser.order(user_id: "DESC").first.user_id + 1
      end
      @user = TempUser.create(user_id: @user_id, name: "Guest")
      @user.save
      cookies.permanent[:user_id] = { :value => @user_id }
    end

    # Questioをインポート
    @questions = Question.where(category: @category).all
    @questions.each do |question|
      @question_id_array.push(question.question_id)
      @question_content_array.push(question.content)
      @question_remain_array.push(question.remain_question_num)
    end

    @question_id_array = @question_id_array.to_json.html_safe
    @question_content_array = @question_content_array.to_json.html_safe
    @question_remain_array = @question_remain_array.to_json.html_safe


    # Optionをインポート
    @options = Option.where(category: @category).all
    @options.each do |option|
      @option_id_array.push(option.option_id)
      @option_question_id_array.push(option.question_id)
      @option_next_question_id_array.push(option.next_question_id)
      @option_content_array.push(option.content)
    end

    @option_id_array = @option_id_array.to_json.html_safe
    @option_question_id_array = @option_question_id_array.to_json.html_safe
    @option_next_question_id_array = @option_next_question_id_array.to_json.html_safe
    @option_content_array = @option_content_array.to_json.html_safe

    # Before Questionsをインポート
    unless cookies[:before_questions].nil?
      @before_question_id_array = cookies[:before_questions].split(",")
      index = @before_question_id_array.length - 1
      this_category = @before_question_id_array[index]
      @before_question_id_array.delete(this_category)
      if this_category != @category
        @before_question_id_array = []
      end
    end
    @before_question_id_array = @before_question_id_array.to_json.html_safe

  end


end
