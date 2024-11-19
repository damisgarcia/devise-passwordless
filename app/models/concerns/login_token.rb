module LoginToken extend ActiveSupport::Concern
  included do
    generates_token_for :login_token

    def password_required?
      false
    end

    def update_password_required?
      false
    end

    def invalidate_login_token!
      update(login_token: nil, login_token_generated_at: nil)
    end

    def regenerate_login_token
      code = SecureRandom.random_number(10**6).to_s.rjust(6, '0')

      update  login_token: code,
              login_token_generated_at: Time.current,
              password: self.generate_token_for(:login_token)

      code
    end

    def login_token_valid?(token)
      login_token_generated_at.present? && login_token_generated_at > 15.minutes.ago
    end
  end
end
