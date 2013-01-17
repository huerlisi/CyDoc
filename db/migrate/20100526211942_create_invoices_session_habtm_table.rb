# -*- encoding : utf-8 -*-
class CreateInvoicesSessionHabtmTable < ActiveRecord::Migration
  def self.up
    create_table "invoices_sessions", :id => false do |t|
      t.integer "invoice_id"
      t.integer "session_id"
    end
    
    add_index :invoices_sessions, [:invoice_id, :session_id]

   for session in Session.all
      execute "INSERT INTO invoices_sessions (invoice_id, session_id) VALUES (#{session.invoice_id}, #{session.id})" if session.invoice_id
    end
    
    remove_column :sessions, :invoice_id
  end

  def self.down
    # This is a destructive migration

    add_column :sessions, :invoice_id, :integer

    for session in Session.all
      session.update_attribute(:invoice_id, session.invoices.first.id) unless session.invoices.empty?
    end

    drop_table "invoices_sessions"
  end
end
