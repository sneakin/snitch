require 'snitch/service'
require 'tmail'
require 'net/smtp'

class Snitch
  module Services
    class Email < Service
      def default_options
        super.merge(:message_length => :superlong)
      end
      
      def tattle(message)
        send_email(create_email(message))
      end

      def send_email(email)
        email_opts = %W(server port host login password auth_method).collect { |attr| lookup(attr) }

        Net::SMTP.start(*email_opts) do |smtp|
          smtp.send_message(email.to_s, from, to)
        end
      end
      
      def create_email(message)
        mail = TMail::Mail.new
        mail.to = to
        mail.from = from
        mail.subject = message[0, message.index("\n") || message.length]
        mail.date = Time.now
        mail.set_content_type 'text', 'plain'
        mail.body = message
        mail
      end

      def lookup(var)
        self.send(var)
      rescue NameError
        nil
      end

    end
  end
end
