json.array!(@webmails) do |webmail|
  json.extract! webmail, :id, :sender_id, :sender_name, :receiver_id, :receiver_type, :content, :ifread
  json.url webmail_url(webmail, format: :json)
end
