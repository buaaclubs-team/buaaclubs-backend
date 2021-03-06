class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /api/articles/:article_id/comments 获取当前文章的评论
  def getcomments
    @article = Article.find(params[:article_id].to_i)
    list = []
    @article.commenets.each{|temp|
				 if(temp.sender_type == 1)
				   @sender = Club.find(temp.sender_id)
				   list <<{
					:uid => @sender.club_account,
					:type => 1,
					:name => @sender.name,
		 			:user_head => @sender.head_url,
					:content => temp.content,
					:time => temp.created_at,
					:comment_id => temp.id
					}
				 else
				   @sender = User.find(temp.sender_id)
				   list <<{
                                        :uid => @sender.stu_num,
					:type => 0,
                                        :name => @sender.name,
                                        :user_head => @sender.user_head,
                                        :content => temp.content,
                                        :time => temp.created_at,
                                        :comment_id => temp.id
                                        }
				 end
    }
    render :json => {:txt => list}.to_json
  end



  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:reply_id, :content, :sender_id, :sender_type)
    end
end
