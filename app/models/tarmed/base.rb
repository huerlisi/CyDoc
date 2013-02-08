# -*- encoding : utf-8 -*-
class Tarmed::Base < ActiveRecord::Base
  self.abstract_class = true

  use_db :prefix => "tarmed_"

  def self.condition_validity
    "GUELTIG_BIS = '2199-12-31 00:00:00'"
  end

  def lang
    'D'
  end

  # Meta info
  def self.int_class
    ::TarmedTariffItem
  end

  def self.int_id
    'code'
  end

  attr_accessor :int_record
  cattr_accessor :log

  # Helpers
  def self.find_int(ext_id)
    if int_id == 'id'
      return nil unless int_class.exists?(ext_id)

      int_class.find(ext_id)
    else
      int_class.first(:conditions => {int_id => ext_id})
    end
  end

  def find_int
    self.class.find_int(@int_record.attributes[self.class.int_id])
  end

  def assign
    if @to_delete
      delete
    else
      @int_record = create_or_update
      @int_record.save!
    end
  end

  def delete
    int_record = find_int

    if int_record
      puts "Deleting #{int_record}"
      int_record.destroy
      puts
    else
      puts "Already deleted #{@int_record}" if @@log == :debug
      puts if @@log == :debug
    end
  end

  def create_or_update
    int_record = find_int

    if int_record
      int_record.attributes = int_record.attributes.merge(@int_record.attributes.reject{|key, value| key == 'updated_at' or key == 'created_at' or key == 'id'})
      unless int_record.changes.empty? or @@log == :debug
        puts "Updating #{int_record}..."
        changes = int_record.changes.map{|column, values| "  #{column}: #{values[0]} => #{values[1]}"}.join("\n")
        puts changes
      end

      create_or_update_associations(int_record) if self.class.method_defined? :create_or_update_associations

    else
      puts "Adding #{@int_record}..."
      int_record = @int_record
      changes = int_record.changes.map{|column, values| "  #{column}: #{values[0]} => #{values[1]}"}.join("\n")
      puts changes if @@log == :debug
    end

    puts unless int_record.changes.empty?

    return int_record
  end

  def import
    @int_record = self.class.int_class.new

      begin
        @int_record.code = self.code
        @int_record.amount_mt = self.amount_mt
        @int_record.amount_tt = self.amount_tt
        @int_record.remark = self.name

        print "ID: #{self.id} OK\n"
      rescue Exception => ex
        print "ID: #{self.id} => #{ex.message}\n\n"
        return
      end

    assign
  end


  def self.import_all(do_clean)
    TarmedTariffItem.delete_all if do_clean

    for tarmed_tariff_item in Tarmed::Leistung.all(:conditions => self.condition_validity)
      begin
        tariff_item = TarmedTariffItem.new

        tariff_item.code = tarmed_tariff_item.code
        tariff_item.amount_mt = tarmed_tariff_item.amount_mt
        tariff_item.amount_tt = tarmed_tariff_item.amount_tt
        tariff_item.remark = tarmed_tariff_item.name

        tariff_item.save
        print "ID: #{tarmed_tariff_item.id} OK\n"
      rescue Exception => ex
        print "ID: #{tarmed_tariff_item.id} => #{ex.message}\n\n"
      end
    end

    return TarmedTariffItem.count
  end
end
