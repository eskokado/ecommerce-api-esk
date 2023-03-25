json.games do
  json.array! @games do |game|
    json.id game.id
    json.mode game.mode
    json.release_date game.release_date
    json.developer game.developer
  end
end
