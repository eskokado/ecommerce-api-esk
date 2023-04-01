json.licenses do
  json.array! @licenses, :id, :key, :game_id, :user_id
end
