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
  end
end
