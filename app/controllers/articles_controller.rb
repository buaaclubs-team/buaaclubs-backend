class ArticlesController < ApplicationController
  skip_before_filter :verify_authenticity_token

 # before_action :set_article, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_user_login, only: [:cutlist,:list, :abstracts, :detail, :index, :edit, :update, :destroy,:create,:show]
  skip_before_action :require_club_login, only: [ :abstracts, :detail, :index]
  before_action :set_article, only: [:show, :edit, :update, :destroy]


  # POST /api/clubs/articles/detail/:article_id/list/delete
  def cutlist
    @article = Article.find(params[:article_id].to_i)
    if @article.nil? 
       render text: 'Article not exist', status: 404 
    end
    suc = false
#    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7"
    #puts request.body.string
   # puts JSON.parse(request.body.string)
  #  puts  @users_id["uids"]
 #   puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    @users_id = JSON.parse(request.body.string)
    puts  @users_id["uids"]
    @users_id["uids"].each{|temp_id|
                            puts temp_id
                            puts @article.id
                            user = User.find_by stu_num: temp_id
                            puts user.id
                            find = false
                            puts @article.notes.length
                            @article.notes.each{|temp_note| if temp_note.user_id == user.id 
                                                                find = true 
                                                                temp_note.destroy
                                                                end }
                            if !find 
                               suc = true
                               render text: 'User not exist', status: 404 
                            
                            end
                            }
    if !suc
       render text: 'success', status: 200
    end
  end

    def list
     clu = Club.where(club_account: request.headers["uid"]).take
     state = 200
     puts clu.articles.length
     art = clu.articles.find(params[:article_id].to_i)
     if art.nil?
        state = 404
     else
      
    s = []
    art.users.each{|a| s<<{:uid => a.stu_num,name: a.name,phone_num: a.phone_num,email: a.email,time: Note.where("article_id = ? AND user_id = ?",params[:article_id].to_i,a.id).take.created_at,content: Note.where("article_id = ? AND user_id = ?",params[:article_id].to_i,a.id).take.content}}
    end    
    respond_to do |format|
        if (state == 200)
         format.html { render :json=>{:txt => s}.to_json }
        else
        format.html { render nothing: true, status: 404 }
        end
    end

  end	
  
  # GET /api/articles/:page_id
  def abstracts
    a = []
    x = params[:page_id].to_i
    if (x<1)
      respond_to do |format|
        format.html { render :json=>{txt: "page_id minus"}.to_json, :status => 404}
      end
    end
    if x>1
      x = (x-1)*5
    else
      x = 1
    end
  # y = Article.last.id.to_i
   # @abstracts = Article.find([x,x+9])
   if x == 1
      p = Article.order(created_at: :desc).limit(5)
   else p = Article.order(created_at: :desc).limit(5).offset(x)
   end
    if p.length == 0
       respond_to do |format|
       format.html { render :json => {:txt => "Not Record"} ,:status => 404}
       end
    else
       p.each{|t| a<<{:article_id => t.id,:article_title => t.title,:article_abstract => t.abstract, :head_url => t.club.head_url} }
       respond_to do |format|
		 response.headers['Access-Control-Allow-Origin']="*"
         format.html { render :json=>{:txt => a}.to_json }
       end
    end
  end

  # GET /api/articles/detail/:article_id
  def detail
   if (Article.exists?(params[:article_id].to_i)== false)
       respond_to do |format|
        format.html { render :json=>{:txt => params[:article_id]}.to_json, :status => 404}
      end
    end
   begin
   @detail =  Article.find(params[:article_id].to_i)
   rescue
     @detail = Article.new
     @detail.title = ""
     @detail.content = ""
   end
    respond_to do |format|
         format.html { render :json => {:title => @detail.title,:content => @detail.content, :head_url => @detail.club.head_url}.to_json }
         end
  end

  
  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    
          clu = Club.where(club_account: request.headers["uid"]).take
          state = 200
          art = clu.articles.find(params[:article_id].to_i)
          if art.nil?
             state = 401
          end
     respond_to do |format|
           if state == 200
           format.html { render :json => {:article_title => art.title,:content => art.content }.to_json  }
           else
           format.html { render nothing: true, status: 401 }
           format.json { render json: @article.errors, status: :unprocessable_entity }

           end
     end       
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    
    @article = Article.new
    @body = JSON.parse(request.body.string)
    @article.title = @body["title"]
    @article.content = @body["content"]
    @article.abstract = @body["abstract"]
    clu = Club.find_by club_account: request.headers["uid"]
    @article.club_id = clu.id
    respond_to do |format|
      if @article.save
        format.html { render nothing: true, status: 200  }
        format.json { render text: 'successed!', status: 200}
      else
       format.html { render text: 'failed!', status: 404 }
       format.json { render json: @article.error, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
   state = 200
   clu = Club.where(club_account: request.headers["uid"]).take
   sss = {}
   @body = JSON.parse(request.body.string)
   
   sss[:title] = @body["title"]
   sss[:content] = @body["content"]
   sss[:abstract] = @body["abstract"]
   sss[:club_id] = clu.id
   puts sss[:title]
   puts sss[:content]
   puts sss[:abstract]
   puts sss[:club_id]
   @article = clu.articles.find(params[:article_id].to_i)
   if @article.nil?
      state = 401
   end
    respond_to do |format|
      if (state == 200)&&@article.update(sss)
        format.html { render nothing: true, status: 200  }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render nothing: true, status: 400 }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    clu = Club.where(club_account: request.headers["uid"]).take
    state = 200
    @article = clu.articles.find(params[:article_id].to_i)

    if @article.nil?
       state = 401
    end
    respond_to do |format|
      if (status == 200)&& @article.destroy
      format.html { render nothing: true, status: 200}
 
      format.json { head :no_content }
      else
      format.html { render nothing: true, status: 404 }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:article_id].to_i)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title,:abstract,:content)
    end
end
