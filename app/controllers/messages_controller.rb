class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message] ? message_params :
      {
        from: params[:from],
        sender: params[:sender],
        subject: params[:subject],
        stripped_text: params['stripped-text'],
        body_plain: params['body-plain'],
        stripped_html: params['stripped-html'],
        body_html: params['body-html'],
        stripped_signature: params['stripped-signature'],
        unique_id: params['References'].try(:split, ' ').try(:first) || params['Message-Id']
      }
    )

    respond_to do |format|
      if @message.save
        send_email(@message)
        format.html { params[:message] ? redirect_to(@message, notice: 'Message was successfully created.') : render(text: "+1") }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def send_email(message)
      is_vendor = params['To'].try(:include?, 'vendor')
      parameters = {
        to: is_vendor ? 'kmusselman@weddingwire.com' : 'mwidmann@weddingwire.com',
        subject: message.subject,
        text: message.stripped_text,
        from: "#{is_vendor ? 'vendor' : 'wedding-user'}@appb6fe1da58dfe443aa09720e568195cd4.mailgun.org"
      }
      $mailgun.messages.send_email(parameters)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:sender, :from, :subject, :stripped_text, :body_plain, :stripped_html, :body_html)
    end
end
