class NotesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_action :require_user_login, only: [:index, :show, :new,:opt]
  skip_before_action :require_club_login
  before_action :set_note, only: [:show, :edit, :update, :destroy]


     def opt
     # s = request.headers['Access-Control-Allow-Headers']
      response.headers['Access-Control-Allow-Method'] = "GET,POST,PUT"
      response.headers['Access-Control-Allow-Headers'] = "uid,token,content-type"
 
  #    response.headers['Access-Control-Max-Age'] = 30
 
      redirect_to  status: 204
 
    end



  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new
    usr = User.where(stu_num: request.headers["uid"]).take
    article = Article.where(title: '欢迎大家').take
    
    @note.user_id = usr.id
    @note.article_id = params[:article_id].to_i
    @note.content = params[:content]
    
    respond_to do |format|
      if @note.save
        format.html { render nothing: true, status: 200 }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :json=>{txt: "note create failed"}, status: 404}
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end
   
    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:article_id,:content)
    end
end
