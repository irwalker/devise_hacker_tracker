require 'devise_hacker_tracker/models/sign_in_failure'

module HackerTracker
  def self.hacker?(ip_address)
    SignInFailure.clear_outdated!

    failures = SignInFailure.recent.where(ip_address: ip_address)
    too_many_attempts?(failures) && too_many_accounts_tried?(failures)
  end

  private

  def self.too_many_attempts?(failures)
    failures.size >= Devise.maximum_attempts_per_ip
  end

  def self.too_many_accounts_tried?(failures)
    distinct_accounts_tried(failures) >= Devise.maximum_accounts_attempted
  end

  def self.distinct_accounts_tried(failures)
    Devise.authentication_keys.map do |method|
      failures.distinct.pluck(method).count
    end.max
  end
end
