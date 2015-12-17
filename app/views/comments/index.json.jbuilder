json.array!(@comments) do |comment|
  json.extract! comment, :id, :reply_id, :content, :sender_id, :sender_type
  json.url comment_url(comment, format: :json)
end
