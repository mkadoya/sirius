class UploadFloaraImagesController < ApplicationController

  IMAGE_EXT = [".gif", ".jpeg", ".jpg", ".png", ".svg"]

  def upload_image
    if params[:file]
      # FileUtils::mkdir_p(Rails.root.join("public/uploads/files"))
      FileUtils::mkdir_p(Rails.root.join("/uploads/files"))

      ext = File.extname(params[:file].original_filename)
      ext = image_validation(ext)
      file_name = "#{SecureRandom.urlsafe_base64}#{ext}"
      # path = Rails.root.join("public/uploads/files/", file_name)
      path = Rails.root.join("/uploads/files/", file_name)

      File.open(path, "wb") {|f| f.write(params[:file].read)}
      view_file = Rails.root.join("/download_file/", file_name).to_s
      view_file = Rails.root.join("/download_file/", file_name).to_s
      render :json => {:link => view_file}.to_json

    else
      render :text => {:link => nil}.to_json
    end
  end

  def image_validation(ext)
    raise "Not allowed" unless IMAGE_EXT.include?(ext)
  end

  def access_file
    # if File.exists?(Rails.root.join("public", "uploads", "files", params[:name]))
    if File.exists?(Rails.root.join("uploads", "files", params[:name]))
      send_data File.read(Rails.root.join("uploads", "files", params[:name])), :disposition => "attachment"
      # send_data File.read(Rails.root.join("public", "uploads", "files", params[:name])), :disposition => "attachment"
    else
      render :nothing => true
    end
  end

end
