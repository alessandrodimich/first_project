module UsersHelper


  def full_name(user)
    [user.first_name, user.last_name].join " "
  end

  def formatted_email
    "#{full_name(user)} <#{@email}>"
  end

  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: full_name(user), class: "gravatar")
  end


end