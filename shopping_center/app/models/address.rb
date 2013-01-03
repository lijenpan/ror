class Address
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Trackable
  include Mongoid::History::Snapshot

  field :street_number, :type => String

  field :street, :type => String
  validates_presence_of :street

  field :municipality, :type => String
  validates_presence_of :municipality

  field :governing_district, :type => String
  validates_presence_of :governing_district
  validates_length_of :governing_district, :is => 2, :message => 'Governing District should be two character abbreviation.'

  field :postal_code, :type => String
  validates_presence_of :postal_code

  embedded_in :shopping_center, :inverse_of => :address

  track_history :on => [:street_number, :street, :municipality, :governing_district, :postal_code],
    :scope => :shopping_center,
    :modified_field => :modifier,
    :version_field => :version,
    :track_create => true,
    :track_update => true,
    :track_destroy => true

  def to_s(format = :long)
    if([:long, :short, :postal].include? format)
      send("#{format}_to_s")
    else
      long_to_s
    end
  end

  private
  def long_to_s
    "#{street_number} #{street} #{municipality}, #{governing_district} #{postal_code}"
  end

  def short_to_s
    "#{municipality}, #{governing_district}"
  end

  def postal_to_s
    "#{street_number} #{street}\n#{municipality} #{governing_district} #{postal_code}"
  end
end
