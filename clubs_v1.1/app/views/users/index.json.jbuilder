json.array!(@users) do |user|
  json.extract! user, :id, :stu_num, :name, :password, :phone_num
  json.url user_url(user, format: :json)
end
