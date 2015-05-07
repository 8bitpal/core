class DistributorMailer < ApplicationMailer
  def welcome(distributor)
    @distributor = distributor

    headers['X-MC-Tags'] = "distributor,welcome"

    send_via_gmail mail to: @distributor.email_to,
                        from: "Will Lau <#{Figaro.env.support_email}>",
                        subject: "#{@distributor.name}, welcome to Bucky Box!"
  end

  def bank_setup(distributor, bank_name)
    @distributor = distributor
    @bank_name = bank_name

    headers['X-MC-Tags'] = "distributor,bank_setup"

    send_via_gmail mail to: @distributor.email_to,
                        from: "Bucky Box Support <#{Figaro.env.support_email}>",
                        subject: "[Bucky Box] Setting up your bank feed"
  end

private

  def send_via_gmail(email)
    email.delivery_method.settings.merge!(
      address:              Figaro.env.gmail_smtp_host,
      port:                 Figaro.env.gmail_smtp_port,
      user_name:            Figaro.env.gmail_smtp_user_name,
      password:             Figaro.env.gmail_smtp_password,
      authentication:       Figaro.env.gmail_smtp_authentication,
      enable_starttls_auto: Figaro.env.gmail_smtp_enable_starttls_auto,
    )

    email
  end
end
