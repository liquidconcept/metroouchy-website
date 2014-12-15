# encoding: utf-8

# Pony general config
Pony.options = {
  to:       Settings.mail.to,
  from:     'no-reply@liquid-concept.ch',
  subject:  'Contact depuis le site MertoOuchy / MetroFlon',
  charset:  'utf-8'
}

if ENV['RACK_ENV'] == 'production'
  Pony.options[:via] = :smtp
  Pony.options[:via_options] = {
            address:              'smtp.mandrillapp.com',
            port:                 587,
            enable_starttls_auto: true,
            user_name:            Settings.mail.smtp.username,
            password:             Settings.mail.smtp.password,
            authentication:       :login,
            domain:               'liquid-concept.ch'
  }
else
  Pony.options[:via] = :test
end
