class User < ActiveRecord::Base
  ROLES = %w(admin moderator)

  has_many :voices

  validates :role,
    :presence => true,
    :inclusion => { :in => ROLES }

  acts_as_authentic do |c|
    c.login_field :email
  end

  # Concat name and email to display both.
  def display_name
    "#{name} <#{email}>"
  end

  # Array of roles for the user
  def role_syms
    [role.to_sym]
  end

  # Returns true if the user has the role :admin
  def admin?
    role_syms.include? :admin
  end

  # Returns true if the user has the role :moderator
  def moderator?
    role_syms.include? :moderator
  end
end
