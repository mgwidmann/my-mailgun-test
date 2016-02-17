Mailgun.configure do |config|
  config.api_key = 'key-c749f6b1f3492c74b039d5c5fd2b3ec9'
  config.domain  = 'appb6fe1da58dfe443aa09720e568195cd4.mailgun.org'
end

$mailgun = Mailgun()
