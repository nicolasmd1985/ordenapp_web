class Comments::CreateComment

  def initialize(order, user, params)
    @order = order
    @user = user
    @params = params
  end

  def process
    @comment = Comment.new
    @comment.order = @order
    @comment.user = @user
    @comment.description = @params[:description]
    
    success = @comment.save
    if success
      [success, @comment]
    else
      [success, false]
    end
  end

end
