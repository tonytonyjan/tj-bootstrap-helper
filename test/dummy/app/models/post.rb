class Post < ActiveRecord::Base
  attr_accessible :content, :title, :image_url
end
