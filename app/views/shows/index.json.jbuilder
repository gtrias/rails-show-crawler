json.array!(@shows) do |show|
  json.extract! show, :id, :name, :description, :active
  json.url show_url(show, format: :json)
end
