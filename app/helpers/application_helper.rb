module ApplicationHelper
  def error_messages(object, field)    
    object.errors[field.to_sym][0]
  end

  def gravatar_for(user, options = {:s => 50})
    RAILS_DEFAULT_LOGGER.debug " ************* USER ********" + user.inspect
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
end
