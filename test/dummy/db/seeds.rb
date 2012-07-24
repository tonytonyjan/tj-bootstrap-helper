120.times{
  Post.create(
    :title => Faker::Lorem.sentence,
    :content => Faker::Lorem.paragraphs.join("\n"),
    :image_url => "http://avatars.plurk.com/5874158-big66.jpg"
  )
}