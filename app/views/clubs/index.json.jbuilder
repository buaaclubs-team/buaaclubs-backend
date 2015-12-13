json.array!(@clubs) do |club|
  json.extract! club, :id, :name, :password, :introduction, :head_url
  json.url club_url(club, format: :json)
end
