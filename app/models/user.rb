class User < ActiveRecord::Base
  # Strategies
  devise :database_authenticatable, :recoverable, :trackable, :timeoutable, :lockable, :rememberable, :validatable

  # CyDoc
  belongs_to :object, :polymorphic => true

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me, :sender_email

  # Tenancy
  belongs_to :tenant
  attr_accessible :tenant

  # Authorization roles
  has_and_belongs_to_many :roles, :autosave => true
  scope :by_role, lambda{|role| include(:roles).where(:name => role)}
  attr_accessible :role_texts

  def role?(role)
    !!self.roles.find_by_name(role.to_s)
  end

  def role_texts
    roles.map{|role| role.name}
  end

  def role_texts=(role_names)
    self.roles = Role.where(:name => role_names)
  end

  # Helpers
  def to_s
    if object
      return object.name
    else
      return email
    end
  end
end
