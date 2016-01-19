json.array!(@phones) do |phone|
  json.extract! phone, :id, :phone_num, :phone_verify_num
  json.url phone_url(phone, format: :json)
end
