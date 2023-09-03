class SessionsController < Devise::SessionsController
  def new
    User.find_or_create_by(email: 'foo@bar.com') do |user|
      user.password = 'foobar'
    end
    super
  end
end