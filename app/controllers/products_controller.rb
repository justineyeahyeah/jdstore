class ProductsController < ApplicationController
  before_action :validate_search_key, only: [:search]

  def index
    if params[:category].blank?
      @products = Product.where(:is_shelved => true).order("position ASC")
    else
      @category_id = Category.find_by(name: params[:category]).id
      @products = Product.where(:is_shelved => true).where(:category_id => @category_id)
    end
  end

  def show
    @product = Product.find(params[:id])
    @comments = @product.comments.order("created_at DESC")
      if @comments.blank?
        @avg_comment = 0
      else
        @avg_comment = @comments.average(:rating).present? ? comments.average(:rating).round(2) : 0
      end
  end

  def add_to_cart
    @product = Product.find(params[:id])
    @quantity = params[:quantity].to_i
    # 判断加入购物车的商品是否超过库存

    if @quantity > @product.quantity # 如果输入的数量大于库存
      @quantity = @product.quantity
      flash[:warning] = "您选择的商品数量超过库存，实际加入购物车的商品为#{@quantity}件。"
    end
    current_cart.add(@product, @quantity)
    redirect_to product_path(@product)
  end



  # search
  def search
    if @query_string.present?
      search_result = Product.where(:is_shelved => true).ransack(@search_criteria).result(:distinct => true)
      @products = search_result.paginate(:page => params[:page], :per_page => 5 )
    end
  end


  protected

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
    @search_criteria = search_criteria(@query_string)
  end


  def search_criteria(query_string)
    { :title_cont => query_string }
  end



  private
  def product_params
    params.require(:product).permit(:title, :description, :quantity, :price, :image, :author, :publisher, :pages, :is_shelved, :publication_date, :category_id)
  end

end
