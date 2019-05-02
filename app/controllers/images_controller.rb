class ImagesController < InheritedResources::Base

  def index
    redirect_to '/admin'
  end

  def show
    redirect_to '/admin'
  end

  def new
    redirect_to '/admin'
  end

  def edit
    redirect_to '/admin'
  end

  def create
    redirect_to '/admin'
  end

  def update
    redirect_to '/admin'
  end

  def destroy
    redirect_to '/admin'
  end

  private

    def image_params
      params.require(:image).permit(:name, :image)
    end
end
