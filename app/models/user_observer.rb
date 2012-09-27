class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.signup_notification(user).deliver
  end

  def after_save(user)

    UserMailer.activation(user).deliver if user.recently_activated?

  end
end
