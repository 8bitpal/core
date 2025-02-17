class AddEmailTemplatesToDistributor < ActiveRecord::Migration[7.0]
  def up
    add_column :distributors, :email_templates, :text

    Distributor.all.each do |distributor|
      email_templates = [
        {
          subject: "Your account is overdue",
          body: <<-BODY
Hi {first_name},

Just a reminder that your account balance is overdue.

Your existing balance is: {account_balance}

You can login to your account to check your account history and make payments here:
#{Rails.application.routes.url_helpers.new_customer_session_url(host: Figaro.env.host, distributor: distributor.parameter_name)}

Cheers
-The team at #{distributor.name}
          BODY
        },
        {
          subject: "Using your login for ordering at #{distributor.name}",
          body: <<-BODY
Hi {first_name},

you can keep up to date with your orders by logging into your account with us here:
#{Rails.application.routes.url_helpers.new_customer_session_url(host: Figaro.env.host, distributor: distributor.parameter_name)}

Use this account to:
- Make or change orders
- Check your transaction history
- Pause your deliveries
- Update your delivery address

SETTING UP A PASSWORD
If you do not have a password or have forgotten it, you can request a new password by using this link below:
#{Rails.application.routes.url_helpers.new_customer_password_url(host: Figaro.env.host, distributor: distributor.parameter_name)}

Cheers
-The team at #{distributor.name}
          BODY
        },
        {
          subject: "Weekly Newsletter - What's in your box this week",
          body: <<-BODY
Hi {first_name},

Thanks for supporting.

WHAT'S IN YOUR BOX THIS WEEK

As you know, we source the best seasonal produce from around the region, so here's some of the delicious fresh items you might find in your box this week;
- INSERT PRODUCE LIST HERE

TOP RECIPE TIPS

Here's our top 3 recipes which include some of the ingredients you have to cook with:
- ADD RECIPE LINKS HERE

BITE SIZE KNOWLEDGE

A key part of what drives us is creating a thriving, diverse food system - it's better for people and planet.

As part of that vision we scour the markets, farms and seedbanks for interesting produce which we add to your delivery.

This week's lesser-known food stuff is INSERT FOOD ITEM HERE, AND A LITTLE INFORMATION ABOUT IT.

FEEDBACK

We love to hear your thoughts, good or bad, about how your experience with us is going. We strive to give you the best food delivery service around, so your insights are vital to us improving.

Drop us an email, tweet (@twitterhandle) or call anytime and we'll get back to you.

Thank you for your loyal custom and for supporting a better food system.

OWNER/CUSTOMER SERVICE NAME
#{distributor.name}
CONTACT DETAILS
          BODY
        },
      ].map do |template|
        EmailTemplate.new template[:subject], template[:body]
      end.freeze

      # NOTE: I could simply assign `email_templates` for each distributor but it
      # takes more than a minute so I use the following hack:
      coder = ActiveRecord::Coders::YAMLColumn.new Array
      serialized_templates = coder.dump(email_templates).freeze

      distributor.update_column 'email_templates', serialized_templates
    end
  end

  def down
    remove_column :distributors, :email_templates
  end
end
