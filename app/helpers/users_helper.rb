module UsersHelper


  def full_name(user)
    [user.first_name, user.last_name].join " "
  end

  def formatted_email
    "#{full_name(user)} <#{@email}>"
  end

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    placehold_it_url = "http://placehold.it/52x52"
    image_tag(gravatar_url, alt: placehold_it_url, class: "gravatar")
  end

end