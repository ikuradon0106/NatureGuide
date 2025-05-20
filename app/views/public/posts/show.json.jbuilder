json.id @post.id
json.title @post.title
json.body @post.body
json.address @post.address
json.latitude @post.latitude
json.longitude @post.longitude

json.user do
  json.name @post.user.nickname
  json.image url_for(@post.user.profile_image) if @post.user.profile_image.attached?
end

json.image url_for(@post.image) if @post.image.attached?
