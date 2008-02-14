class CreateCasesMailings < ActiveRecord::Migration
  def self.up
    create_table :cases_mailings, :id => false do |t|
      t.integer :case_id, :mailing_id
    end
    
    add_index :cases_mailings, :case_id
    add_index :cases_mailings, :mailing_id
  end

  def self.down
    drop_table :cases_mailings
  end
end
