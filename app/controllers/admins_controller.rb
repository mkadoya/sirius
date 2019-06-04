class AdminsController < ApplicationController
    before_action :authenticate_user!

    def index
        @categories = Category.all
        @logs = params[:logs]
        @category  = params[:category] ? params[:category] : "pc"
        @questions = Question.where(category: @category).all
        @question_groups = Array.new
        @columns = Column.where(category: @category).all
        @questions.each do |question|
            @question_groups.push(QuestionGroup.new(question.question_id))
        end
        @new_option_id = Option.all.maximum(:option_id) + 1
    end

    def update
        @question_id = params[:question_id]
        @question_content = params[:question_content]
        @remain_question_num = params[:remain_question_num]
        @option_id = params[:option_id]
        @option_content = params[:option_content]
        @next_question_id = params[:next_question_id]
        @match_option_id = params[:match_option_id]
        @match_id = params[:match_id]
        @match_column = params[:match_column]
        @match_max = params[:match_max]
        @match_min = params[:match_min]

        # 採番するMatch ID
        @new_match_id = Match.all.maximum(:match_id) + 1

        # 各種配列の定義
        @remove_options = Array.new
        @remove_matches = Array.new
        @add_option_id = Array.new
        @change_option_id = Array.new
        @option_id.each do |option_id|
            @add_option_id.push(option_id.to_i)
            @change_option_id.push(option_id.to_i)
        end
        @add_options = Array.new
        @add_matches = Array.new

        # 追加・削除・変更のログ
        @logs = Array.new

        # 更新するCategoryを定義する
        @category = Question.find_by(question_id: @question_id).category
        # 更新するCategoryの定義はここまで

        # 削除する対象のOption Idの定義
        options = Option.where(question_id: @question_id).all
        options.each do |option|
            @remove_options.push(option.option_id)
        end
        unless @option_id.nil?
            @option_id.each do |option_id|
                option_id = option_id.to_i
                @remove_options.delete(option_id)
            end
        end
        # 削除する対象のOption Idの定義はここまで

        # 削除する対象のMatch Idの定義
        options.each do |option|
            matches = Match.where(option_id: option.option_id).all
            matches.each do |match|
                @remove_matches.push(match.match_id)
            end
        end
        unless @match_id.nil?
            @match_id.each do |match_id|
                match_id = match_id.to_i
                @remove_matches.delete(match_id)
            end
        end
        # 削除する対象のMatch Idの定義はここまで

        # 追加する対象のOptionの定義
        options.each do |option|
            @add_option_id.delete(option.option_id)
        end
        index = 0
        @option_id.each do |option_id|
            if @add_option_id.include?(option_id.to_i)
                hash = {
                    option_id: option_id.to_i,
                    content: @option_content[index],
                    next_question_id: @next_question_id[index].to_i
                }
                @add_options.push(hash)
            end
            index += 1
        end
        # 追加する対象のOptionの定義はここまで

        # 追加する対象のMatchの定義
        index = 0
        @match_id.each do |match_id|
            if match_id == "0"
                option_id = @match_option_id[index]

                hash = {
                    match_id: @new_match_id,
                    option_id: option_id,
                    item_clmn: @match_column[index],
                    max: @match_max[index].to_i,
                    min: @match_min[index].to_i
                }
                @add_matches.push(hash)
                @new_match_id += 1
            end
            index += 1

        end
        # 追加する対象のMatchの定義はここまで

        # Questionの変更の実行
        question = Question.find_by(question_id: @question_id.to_i )
        if question.content != @question_content
            log = '[Change] question_id : ' + @question_id + '  (content) before: ' + question.content + ', after: ' + @question_content
            @logs.push(log)
            question.content = @question_content
            question.save
        end
        if question.remain_question_num != @remain_question_num.to_i
            log = '[Change] question_id : ' + @question_id + '  (remain_questin_num) before: ' + question.remain_question_num.to_s + ', after: ' + @remain_question_num
            @logs.push(log)
            question.remain_question_num = @remain_question_num.to_i
            question.save
        end
        # Questionの変更の実行はここまで

        # Optionの変更の実行
        @add_option_id.each do |add_option_id|
            @change_option_id.delete(add_option_id)
        end
        index = 0
        @option_id.each do |option_id|
            option_id = option_id.to_i
            if @change_option_id.include?(option_id)
                option = Option.find_by(option_id: option_id)
                if option.content != @option_content[index]
                    log = '[Change] option_id : ' + option_id.to_s + '  (content) before: ' + option.content + ', after: ' + @option_content[index]
                    @logs.push(log)
                    option.content = @option_content[index]
                    option.save
                end
                if option.next_question_id != @next_question_id[index].to_i
                    log = '[Change] option_id : ' + option_id.to_s + '  (next_question_id) before: ' + option.next_question_id.to_s + ', after: ' + @next_question_id[index]
                    @logs.push(log)
                    option.next_question_id = @next_question_id[index].to_i
                    option.save
                end
            end
            index += 1
        end
        # 変更する対象のOptionの定義はここまで

        # 削除の実行
        unless @remove_options.nil?
            @remove_options.each do |option_id|
                option = Option.find_by(option_id: option_id)
                log = '[Delete] option_id : ' + option.option_id.to_s + ', content : ' + option.content + ', question_id: ' + option.question_id.to_s
                @logs.push(log)
                option.destroy
            end
        end

        unless @remove_matches.nil?
            @remove_matches.each do |match_id|
                match = Match.find_by(match_id: match_id)
                log = '[Delete] match_id : ' + match.match_id.to_s + ', option_id : ' + match.option_id.to_s + ', item_clmn : ' + match.item_clmn + ', max : ' + match.max.to_s + ', match.min : ' + match.min.to_s
                @logs.push(log)
                match.destroy
            end
        end
        # 削除の実行はここまで

        # 追加の実行
        @add_options.each do |option|
            add_option = Option.new(option_id: option[:option_id],category: @category,question_id: @question_id.to_i,content: option[:content],next_question_id: option[:next_question_id])
            add_option.save
            log = '[Add] option_id : ' + add_option.option_id.to_s + ', content : ' + add_option.content + ', question_id: ' + add_option.question_id.to_s
            @logs.push(log)
        end
        @add_matches.each do |match|
            add_match = Match.new(match_id: match[:match_id], category: @category, option_id: match[:option_id],item_clmn: match[:item_clmn],min: match[:min],max: match[:max])
            add_match.save
            log = '[Add] match_id : ' + add_match.match_id.to_s + ', option_id : ' + add_match.option_id.to_s + ', item_clmn : ' + add_match.item_clmn + ', max : ' + add_match.max.to_s + ', match.min : ' + add_match.min.to_s
            @logs.push(log)
        end
        # 追加の実行はここまで

        @all_delete = params[:all_delete]
        # 全削除の実行
        if @all_delete
            @delete_question = Question.find_by(question_id: @question_id)
            @delete_options = Option.where(question_id: @question_id).all
            @delete_match_id = Array.new
            @delete_options.each do |option|
                matches = Match.where(option_id: option.option_id).all
                matches.each do |match|
                    @delete_match_id.push(match.match_id)
                end
            end
            log = '[Delete] question_id : ' + @delete_question.question_id.to_s + ', content : ' + @delete_question.content + ', remain_question_num: ' + @delete_question.remain_question_num.to_s
            @logs.push(log)
            @delete_question.destroy
            @delete_question.save

            @delete_options.each do |option|
                log = '[Delete] option_id : ' + option.option_id.to_s + ', content : ' + option.content + ', question_id: ' + option.question_id.to_s
                @logs.push(log)
                option.destroy
                option.save
            end
            @delete_match_id.each do |match_id|
                match = Match.find_by(match_id: match_id)
                log = '[Delete] match_id : ' + match.match_id.to_s + ', option_id : ' + match.option_id.to_s + ', item_clmn : ' + match.item_clmn + ', max : ' + match.max.to_s + ', match.min : ' + match.min.to_s
                @logs.push(log)
                match.destroy
                match.save
            end
        end
        # 全削除の実行はここまで

        redirect_to :controller => "admins", :action => "index", :category => @category, :logs => @logs and return
    end

    def new
        @category = params[:category]
        @new_option_id = Option.all.maximum(:option_id) + 1
        @columns = Column.where(category: @category).all
    end

    def create
        @logs = Array.new
        @category = params[:category]
        @question_id = Question.all.maximum(:question_id) + 1
        @question_content = params[:question_content]
        @remain_question_num = params[:remain_question_num]
        @option_id = params[:option_id]
        @option_content = params[:option_content]
        @next_question_id = params[:next_question_id]
        @match_option_id = params[:match_option_id]
        @match_id = Match.all.maximum(:match_id) + 1
        @match_column = params[:match_column]
        @match_max = params[:match_max]
        @match_min = params[:match_min]

        log = '[Add] question_id : ' + @question_id.to_s + ' content : ' + @question_content + ' remain_question_num: ' + @remain_question_num.to_s
        @logs.push(log)
        question = Question.new(category: @category, content: @question_content, question_id: @question_id, remain_question_num: @remain_question_num )
        question.save

        for num in 0..(@option_id.length-1) do
            log = '[Add] option_id : ' + @option_id[num].to_s + ', content : ' + @option_content[num] + ', question_id: ' + @question_id.to_s + ', next_question_id: ' + @next_question_id[num]
            @logs.push(log)
            option = Option.new(option_id: @option_id[num], category: @category, question_id: @question_id, content: @option_content[num], next_question_id: @next_question_id[num].to_i )
            option.save
            for num2 in 0..(@match_option_id.length-1) do
                if @match_option_id[num2].to_i == @option_id[num].to_i
                    log = '[Add] match_id : ' + @match_id.to_s + ', option_id : ' +  @match_option_id[num2].to_s + ', item_clmn : ' + @match_column[num2] + ', max : ' + @match_max[num2].to_s + ', match.min : ' + @match_min[num2].to_s
                    @logs.push(log)
                    match = Match.new(match_id: @match_id,category: @category,option_id:@match_option_id[num2],item_clmn:@match_column[num2],max:@match_max[num2],min: @match_min[num2])
                    match.save
                    @match_id += 1
                end
            end
        end

        redirect_to :controller => "admins", :action => "index", :category => @category, :logs => @logs and return
    end

end


class QuestionGroup

    def initialize(question_id)
        @question = Question.find_by(question_id: question_id)
        @options = Option.where(question_id: question_id).all
        @option_groups = Array.new
        @options.each do |option|
            @option_groups.push(OptionGroup.new(option.option_id))
        end

    end

    def getQuestionContent
        return @question.content
    end

    def getQuestionId
        return @question.question_id
    end

    def getQuestionRemain
        return @question.remain_question_num
    end

    def getOptionGroups
        return @option_groups
    end

end

class OptionGroup
    def initialize(option_id)
        @option = Option.find_by(option_id: option_id)
        @matches = Match.where(option_id: option_id).all
    end

    def getOption
        return @option
    end

    def getMatches
        return @matches
    end
end
