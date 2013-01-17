# -*- encoding : utf-8 -*-
class CreateTenantIfNone < ActiveRecord::Migration
  def up
    return unless Tenant.count == 0

    tenant = Tenant.new
    tenant.users = User.all
    tenant.save

    Role::NAMES.each do |name|
      Role.create!(:name => name)
    end

    User.all.each do |user|
      user.role_texts = ["sysadmin"]
    end
  end
end
