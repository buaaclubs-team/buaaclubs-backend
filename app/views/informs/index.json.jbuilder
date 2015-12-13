json.array!(@informs) do |inform|
  json.extract! inform, :id
  json.url inform_url(inform, format: :json)
end
