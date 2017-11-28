class Image < ActiveRecord::Base
  include Protectable
  attr_accessor :image_content

  has_many :thing_images, inverse_of: :image, dependent: :destroy
  has_many :things, through: :thing_images

  composed_of :position,
              class_name:"Point",
              allow_nil: true,
              mapping: [%w(lng lng), %w(lat lat)]

  scope :including,    -> (ids) { where(id: ids) }
  scope :excluding,    -> (ids) { where.not(id: ids) }

  acts_as_mappable
  def to_lat_lng
    Geokit::LatLng.new(lat,lng)
  end

  def self.with_distance(origin, scope)
    scope.select("-1 as distance")
         .each {|image| image.distance = image.distance_from(origin) }
  end

  def basename
    caption || "image-#{id}"
  end
end

Point.class_eval do
  def to_lat_lng
    Geokit::LatLng.new(*latlng)
  end
end
