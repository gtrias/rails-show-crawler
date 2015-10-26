# Non database model approach
# http://railscasts.com/episodes/219-active-model
class Link
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :url, :quality, :show, :season, :chapter

  validates_presence_of :url

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
