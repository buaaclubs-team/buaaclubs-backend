json.array!(@phone_nums) do |phone_num|
  json.extract! phone_num, :id, :phone_num, :phone_verify_num
  json.url phone_num_url(phone_num, format: :json)
end
