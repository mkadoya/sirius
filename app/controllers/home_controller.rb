class HomeController < ApplicationController
  def top
    @user_id = cookies[:user_id].presence || 0
    @articles = Article.order(id: :desc).first(10)
    @laptops = Array.new
    @result_displayed = false

    # 結果の表示判定
    if (OptionResult.where(user_id: @user_id).count > 0)
      @result_displayed = true
    end

    # 人気のノートパソコンの表示
    @laptop = {"image" => Item.find_by(series:"Surface Pro 6 128GB").image, "url" => "89", "series" => "Surface Pro 6 128GB"}
    @laptops.push(@laptop)
    @laptop = {"image" => Item.find_by(series:"Surface Laptop 2 LQL 128GB").image, "url" => "77", "series" => "Surface Laptop 2 LQL 128GB"}
    @laptops.push(@laptop)
    @laptop = {"image" => Item.find_by(series:"VivoBook S13 S330UA").image, "url" => "10", "series" => "VivoBook S13 S330UA"}
    @laptops.push(@laptop)
    @laptop = {"image" => Item.find_by(series:"Ideapad S130 ").image, "url" => "46", "series" => "Ideapad S130 "}
    @laptops.push(@laptop)
    @laptop = {"image" => Item.find_by(series:"ZenBook 14 UX430UA").image, "url" => "16", "series" => "ZenBook 14 UX430UA"}
    @laptops.push(@laptop)


  end
end
