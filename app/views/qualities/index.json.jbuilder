json.array!(@qualities) do |quality|
  json.extract! quality, :id, :name, :order
  json.url quality_url(quality, format: :json)
end
