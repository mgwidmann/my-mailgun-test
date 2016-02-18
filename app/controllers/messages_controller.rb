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
                              <a href="http://mandrillapp.com/track/click/30252=
      814/localhost?p=eyJzIjoiY2lYRmdmLV9fckFKbGNHM2Q2alBCSlQ2V0VZIiwidiI6MSwic=
      CI6IntcInVcIjozMDI1MjgxNCxcInZcIjoxLFwidXJsXCI6XCJodHRwOlxcXC9cXFwvbG9jYWxo=
      b3N0OjMwMDBcXFwvdmVuZG9yc1xcXC9ob21lXCIsXCJpZFwiOlwiOTA1NjU3Mzg5ZjdjNGNiZjk=
      2ZjQ4YzY4ODg3N2VhOGRcIixcInVybF9pZHNcIjpbXCJiYjVmMzdlZjEzNjI1ZGQ3NThlMDNhOW=
      ZmZDU4ZjU2N2UzYjM3NDdmXCJdfSJ9"><img alt="WeddingWire" class="header-ba=
      se" style="height: auto; width: 222px" src="https://www.weddingwire.com/assets/logos/weddingwire-logo_2x.png"></a>
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
                    <tr class="connect-with" style="background: #dfdfdd; marg=
      in: 0; padding: 0 0 5px" bgcolor="#dfdfdd">
                      <table class="full-width" style="width: 100%">
                        <tr>
                          <td>
                            <table>
                              <td style="color: #626262">
                                <strong>Connect with WeddingWire:</strong>
                              </td>
                              <td class="lead-email-sm-padding" style="paddin=
      g-left: 5px; padding-right: 5px">
                                <a target="_blank" href="http://mandrillapp.c=
      om/track/click/30252814/www.facebook.com?p=eyJzIjoidnl3UUF5YmR1cVFESGJuen=
      BxZUVvVDVpcHdNIiwidiI6MSwicCI6IntcInVcIjozMDI1MjgxNCxcInZcIjoxLFwidXJsXCI6X=
      CJodHRwOlxcXC9cXFwvd3LmZhY2Vib29rLmNvbVxcXC9XZWRkaW5nV2lyZUVEVVwiLFwiaWRc=
      IjpcIjkwNTY1NzM4OWY3YzRjYmY5NmY0OGM2ODg4NzdlYThkXCIsXCJ1cmxfaWRzXCI6W1wiMTJ=
      lNzczNmUxYWIyYzg0Yjg5OGRkYTAxMDYwNjJlNDJlYzBiNTk1NFwiXX0ifQ"><img alt="Fa=
      cebook" src="http://localhost:3000/assets/vendor/email/fb.gif"></a>
                              </td>
                              <td class="lead-email-sm-padding" style="paddin=
      g-left: 5px; padding-right: 5px">
                                <a target="_blank" href="http://mandrillapp.c=
      om/track/click/30252814/twitter.com?p=eyJzIjoibkRHa0NLY01Cc2djQ0VLMVBiUXB=
      KemlGcDYwIiwidiI6MSwicCI6IntcInVcIjozMDI1MjgxNCxcInZcIjoxLFwidXJsXCI6XCJodH=
      RwczpcXFwvXFxcL3R3aXR0ZXIuY29tXFxcLlZGRpbmd3aXJlRURVXCIsXCJpZFwiOlwiOTA1N=
      jU3Mzg5ZjdjNGNiZjk2ZjQ4YzY4ODg3N2VhOGRcIixcInVybF9pZHNcIjpbXCJmODUxMzM3NzFk=
      MDIwMTFmYTZlM2JmNGNjMDlhYWQ3NTZjOTYxOWIxXCJdfSJ9"><img alt="Twitter" src=
      ="http://localhost:3000/assets/vendor/email/tw.gif"></a>
                              </td>
                              <td class="lead-email-sm-padding" style="paddin=
      g-left: 5px; padding-right: 5px">
                                <a target="_blank" href="http://mandrillapp.c=
      om/track/click/30252814/pinterest.com?p=eyJzIjoiZ1hFOVIzZ0lZblZrOFA2RHZVc=
      XB6RXNFSmhrIiwidiI6MSwicCI6IntcInVcIjozMDI1MjgxNCxcInZcIjoxLFwidXJsXCI6XCJo=
      dHRwOlxcXC9cXFwvcGludGVyZXN0LmNvbVxcXC93ZWRkaW5nd2lyZWVkdVxcXC9cIixcImlkXCI=
      6XCI5MDU2NTczODlmN2M0Y2JmOTZmNDhjNjg4ODc3ZWE4ZFwiLFwidXJsX2lkc1wiOltcImYxNW=
      M2NmQwYjAzMWVhYTU5Yzg3ODAxMGJiNzA3ZDUxZDU2NDRhOWRcIl19In0"><img alt="Pint=
      erest" src="http://localhost:3000/assets/vendor/email/pint.gif"></a>
                              </td>
                              <td class="lead-email-sm-padding" style="paddin=
      g-left: 5px; padding-right: 5px">
                                <a target="_blank" href="http://mandrillapp.c=
      om/track/click/30252814/problog.weddingwire.com?p=eyJzIjoib21UcS1TTXkxcUd=
      6d1ZHNmRxQmFHUDdLWVlNIiwidiI6MSwicCI6IntcInVcIjozMDI1MjgxNCxcInZcIjoxLFwidX=
      JsXCI6XCJodHRwOlxcXC9cXFwvcHJvYmxvZy53ZWRkaW5nd2lyZS5jb21cXFwvXCIsXCJpZFwiO=
      lwiOTA1NjU3Mzg5ZjdjNGNiZjk2ZjQ4YzY4ODg3N2VhOGRcIixcInVybF9pZHNcIjpbXCIxYzg2=
      ZjY4ZGU0NDM4NjRiMjY1MWU0ZDIxMDc1NTRjNWI1YTA3ZjhjXCJdfSJ9"><img alt="Blog"=
       src="http://localhost:3000/assets/vendor/email/rss.gif"></a>
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
                            <div class="gray-text" style="color: #5e5e5e">=C2=
      =A9 WeddingWire, Inc., 2015</div>
                          </td>
                        </tr>
                        <tr></tr>
                        <tr>
                          <td>
                            <a style="color: #5e5e5e; text-decoration: none" cl=
      ass="gray-text" href="http://mandrillapp.com/track/click/30252814/local=
      host?p=eyJzIjoiY2lYRmdmLV9fckFKbGNHM2Q2alBCSlQ2V0VZIiwidiI6MSwicCI6IntcIn=
      VcIjozMDI1MjgxNCxcInZcIjoxLFwidXJsXCI6XCJodHRwOlxcXC9cXFwvbG9jYWxob3N0OjMwM=
      DBcXFwvdmVuZG9yc1xcXC9ob21lXCIsXCJpZFwiOlwiOTA1NjU3Mzg5ZjdjNGNiZjk2ZjQ4YzY4=
      ODg3N2VhOGRcIixcInVybF9pZHNcIjpbXCJiYjVmMzdlZjEzNjI1ZGQ3NThlMDNhOWZmZDU4ZjU=
      2N2UzYjM3NDdmXCJdfSJ9">Two Wisconsin Circle, 3rd Floor, Chevy Chase, MD 208=
      15</a>
                          </td>
                        </tr>
                        <tr>
                          <td>
                            <a target="_blank" class="gray-text" href="http=
      ://mandrillapp.com/track/click/30252814/localhost?p=eyJzIjoiaV9mU1dNb0dEV=
      VBNNXEwZ0ZkSUtCNm1xYjNnIiwidiI6MSwicCI6IntcInVcIjozMDI1MjgxNCxcInZcIjoxLFwi=
      dXJsXCI6XCJodHRwOlxcXC9cXFwvbG9jYWxob3N0OjMwMDBcXFwvdmVuZG9yc1xcXC9sb2dpblw=
      iLFwiaWRcIjpcIjkwNTY1NzM4OWY3YzRjYmY5NmY0OGM2ODg4NzdlYThkXCIsXCJ1cmxfaWRzXC=
      I6W1wiMjUwMjJiZmZjNDFmMGVlNzQ5YTJlODM4NGVkZWQ1OTNjZDkzZDQ5MVwiXX0ifQ" style=
      ="color: #5e5e5e">Log In</a>
                            |
                            <a target="_blank" class="gray-text" href="mail=
      to:pros@weddingwire.com" style="color: #5e5e5e">Contact Us</a>
                            |
                            <a target="_blank" class="gray-text" href="http=
      ://mandrillapp.com/track/click/30252814/localhost?p=eyJzIjoiX1ZfYklsbkdCU=
      mRrbjJNY2NhR0JKVGQ2ZUFvIiwidiI6MSwicCI6IntcInVcIjozMDI1MjgxNCxcInZcIjoxLFwi=
      dXJsXCI6XCJodHRwOlxcXC9cXFwvbG9jYWxob3N0OjMwMDBcXFwvY29ycFxcXC9sZWdhbFxcXC9=
      wcml2YWN5LXBvbGljeVwiLFwiaWRcIjpcIjkwNTY1NzM4OWY3YzRjYmY5NmY0OGM2ODg4NzdlYT=
      hkXCIsXCJ1cmxfaWRzXCI6W1wiZDg2M2QwYTU1ZWI1NTFkZTQwODAxZmQzNjNiYjU0M2IyZGZkN=
      zljNFwiXX0ifQ" style="color: #5e5e5e">Privacy Policy</a>
                            |
                            <a target="_blank" class="gray-text" href="http=
      ://mandrillapp.com/track/click/30252814/localhost?p=eyJzIjoiM09pd24xZlluR=
      VBUcXlZQUZpTktiVFp3T2J3IiwidiI6MSwicCI6IntcInVcIjozMDI1MjgxNCxcInZcIjoxLFwi=
      dXJsXCI6XCJodHRwOlxcXC9cXFwvbG9jYWxob3N0OjMwMDBcXFwvdmVuZG9yc1xcXC92ZW5kb3J=
      fdXNlcnNcIixcImlkXCI6XCI5MDU2NTczODlmN2M0Y2JmOTZmNDhjNjg4ODc3ZWE4ZFwiLFwidX=
      JsX2lkc1wiOltcIjk2N2QxOTcwZDAxMDVkN2IyNGE5OWQ4MmViZDQ3MTJlZjE1MmQ4MmNcIl19I=
      n0" style="color: #5e5e5e">Manage Your Preferences</a>
                          </td>
                        </tr>
                      </table>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>
        <img src="http://mandrillapp.com/track/open.php?u=30252814&id=90565=
      7389f7c4cbf96f48c688877ea8d" height="1" width="1"></body>
      </html>
      HTML
    end
end
