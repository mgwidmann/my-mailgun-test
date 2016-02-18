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
        html: html(message),
        from: "#{is_vendor ? 'wedding-user' : 'vendor'}@appb6fe1da58dfe443aa09720e568195cd4.mailgun.org"
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

    def html(message)
      <<-HTML
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        </head>
        <body>
      <style type="text/css">
      .panel-body:before {
      content: " "; display: table;
      }
      .panel-body:after {
      content: " "; display: table;
      }
      .panel-body:after {
      clear: both;
      }
      .panel-body:before {
      content: " "; display: table;
      }
      .panel-body:after {
      content: " "; display: table;
      }
      .panel-body:after {
      clear: both;
      }
      </style>
          <div align="center" class="system-email-body" style="background: white; margin: 0; padding: 0">
            <table class="full-width" style="width: 100%">
              <tr>
                <td align="center" class="full-width" id="wrapper" style="width: 100%">
                  <table class="full-width" style="width: 100%">
                    <tr>
                      <td>
                        <table>
                          <tr>
                            <td>
                              <img alt="WeddingWire" class="header-base" style="height: auto; width: 222px" src="https://www.weddingwire.com/assets/logos/weddingwire-logo_2x.png">
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr class="system-email-content" style="background: #FFFFFF; color: #535353; font-size: 13px; line-height: 15px; margin: 0; padding: 10px" bgcolor="#FFFFFF">
                      <td class="email-content" style="background: white; padding: 10px" bgcolor="white">
                        #{message.stripped_html}
                      </td>
                    </tr>
                    <tr class="connect-with" style="background: #dfdfdd; margin: 0; padding: 0 0 5px" bgcolor="#dfdfdd">
                      <table class="full-width" style="width: 100%">
                        <tr>
                          <td>
                            <table>
                              <td style="color: #626262">
                                <strong>Connect with WeddingWire:</strong>
                              </td>
                              <td class="lead-email-sm-padding" style="padding-left: 5px; padding-right: 5px">
                                <img alt="Facebook" src="https://www.weddingwire.com/assets/vendor/email/fb.gif">
                              </td>
                              <td class="lead-email-sm-padding" style="padding-left: 5px; padding-right: 5px">
                                <img alt="Twitter" src="https://www.weddingwire.com/assets/vendor/email/tw.gif">
                              </td>
                              <td class="lead-email-sm-padding" style="padding-left: 5px; padding-right: 5px">
                                <img alt="Pinterest" src="https://www.weddingwire.com/assets/vendor/email/pint.gif">
                              </td>
                              <td class="lead-email-sm-padding" style="padding-left: 5px; padding-right: 5px">
                                <img alt="Blog" src="https://www.weddingwire.com/assets/vendor/email/rss.gif">
                              </td>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </tr>
                    <tr>
                      <table class="full-width" style="width: 100%">
                        <tr>
                          <td>
                            <div class="gray-text" style="color: #5e5e5e">WeddingWire, Inc., 2015</div>
                          </td>
                        </tr>
                        <tr></tr>
                        <tr>
                          <td>
                            Two Wisconsin Circle, 3rd Floor, Chevy Chase, MD 208 15
                          </td>
                        </tr>
                        <tr>
                          <td>
                            Log In
                            |
                            Contact Us
                            |
                            Privacy Policy
                            |
                            Manage Your Preferences
                          </td>
                        </tr>
                      </table>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>
        </body>
      </html>
      HTML
    end
end
