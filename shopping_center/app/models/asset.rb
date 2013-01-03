class Asset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  if Rails.env.production?
    has_mongoid_attached_file :attachment,
      :storage => :s3,
      :s3_credentials => "#{Rails.root}/config/aws.yml",
      :bucket => :pps_ShoppingCenter_prod,
      :path => ":attachment/:id/original/:filename"
  else
    has_mongoid_attached_file :attachment
  end

  embedded_in :shopping_center, :inverse_of => :assets
end
