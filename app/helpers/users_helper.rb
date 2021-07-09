module UsersHelper
  def gravatar_for(user, options = { size: 80, h: 28, w: 28 })
    size = options[:size]
    w = options[:w]
    h = options[:h]
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "w-#{w} h-#{h} rounded-lg")
  end
end
