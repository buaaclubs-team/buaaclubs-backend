json.array!(@applications) do |application|
  json.extract! application, :id
  json.url application_url(application, format: :json)
end
