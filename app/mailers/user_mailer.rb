class UserMailer < ApplicationMailer

  def invite_user user
    @user = user
    mail to: user.email, subject: t("sessions.reset")
  end
end
