json.array!(@messages) do |message|
  json.extract! message, :id, :sender, :from, :subject, :stripped_text, :body_plain, :stripped_html, :body_html, :stripped_signature
  json.url message_url(message, format: :json)
end
