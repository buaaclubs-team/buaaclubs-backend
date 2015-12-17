class WebmailsController < ApplicationController
  before_action :set_webmail, only: [:show, :edit, :update, :destroy]

  # GET /webmails
  # GET /webmails.json
  def index
    @webmails = Webmail.all
  end

  # GET /webmails/1
  # GET /webmails/1.json
  def show
  end

  # GET /webmails/new
  def new
    @webmail = Webmail.new
  end

  # GET /webmails/1/edit
  def edit
  end

  # POST /webmails
  # POST /webmails.json
  def create
    @webmail = Webmail.new(webmail_params)

    respond_to do |format|
      if @webmail.save
        format.html { redirect_to @webmail, notice: 'Webmail was successfully created.' }
        format.json { render :show, status: :created, location: @webmail }
      else
        format.html { render :new }
        format.json { render json: @webmail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /webmails/1
  # PATCH/PUT /webmails/1.json
  def update
    respond_to do |format|
      if @webmail.update(webmail_params)
        format.html { redirect_to @webmail, notice: 'Webmail was successfully updated.' }
        format.json { render :show, status: :ok, location: @webmail }
      else
        format.html { render :edit }
        format.json { render json: @webmail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webmails/1
  # DELETE /webmails/1.json
  def destroy
    @webmail.destroy
    respond_to do |format|
      format.html { redirect_to webmails_url, notice: 'Webmail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_webmail
      @webmail = Webmail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def webmail_params
      params.require(:webmail).permit(:sender_id, :sender_name, :receiver_id, :receiver_type, :content, :ifread)
    end
end
