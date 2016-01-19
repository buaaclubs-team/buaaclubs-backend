class PhoneNumsController < ApplicationController
  before_action :set_phone_num, only: [:show, :edit, :update, :destroy]

  # GET /phone_nums
  # GET /phone_nums.json
  def index
    @phone_nums = PhoneNum.all
  end

  # GET /phone_nums/1
  # GET /phone_nums/1.json
  def show
  end

  # GET /phone_nums/new
  def new
    @phone_num = PhoneNum.new
  end

  # GET /phone_nums/1/edit
  def edit
  end

  # POST /phone_nums
  # POST /phone_nums.json
  def create
    @phone_num = PhoneNum.new(phone_num_params)

    respond_to do |format|
      if @phone_num.save
        format.html { redirect_to @phone_num, notice: 'Phone num was successfully created.' }
        format.json { render :show, status: :created, location: @phone_num }
      else
        format.html { render :new }
        format.json { render json: @phone_num.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phone_nums/1
  # PATCH/PUT /phone_nums/1.json
  def update
    respond_to do |format|
      if @phone_num.update(phone_num_params)
        format.html { redirect_to @phone_num, notice: 'Phone num was successfully updated.' }
        format.json { render :show, status: :ok, location: @phone_num }
      else
        format.html { render :edit }
        format.json { render json: @phone_num.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phone_nums/1
  # DELETE /phone_nums/1.json
  def destroy
    @phone_num.destroy
    respond_to do |format|
      format.html { redirect_to phone_nums_url, notice: 'Phone num was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phone_num
      @phone_num = PhoneNum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phone_num_params
      params.require(:phone_num).permit(:phone_num, :phone_verify_num)
    end
end
