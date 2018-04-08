# Invitable Gem

The most popular gem for invitation - Devise Invitable - is not suitable for building API only app. It is also too customized with default sending of mailer. I want to develop an alternative gem that is more light weight, and require more customization.

Key features of the gem:
1. `invite!` method to send invitation
    a. Will call the default mailer generated in ActionMailer where developer can customize
    b. Will generate an invitation token and save in in the user. Save the encoded token in the user database
```ruby
raw, enc = Devise.token_generator.generate(User, :invitation_token)
```

2. user can accept invitation

Further roadmap
1. Set a limit on how many times a user can send invitation
2. View invitations sent, and resend invitation
3. Set the deadline for accepting invitations
