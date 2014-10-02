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

  def assign
    @int_record = create_or_update
    @int_record.save!
  end

  def create_or_update
    puts "Adding #{@int_record}..."
    int_record = @int_record
    changes = int_record.changes.map{|column, values| "  #{column}: #{values[0]} => #{values[1]}"}.join("\n")
    puts changes if @@log == :debug

    puts unless int_record.changes.empty?

    return int_record
  end

  def self.import_all(do_clean)
    TarmedTariffItem.delete_all if do_clean

    TarmedTariffItem.transaction do
      Tarmed::Leistung.uniq.where(self.condition_validity).find_each do |tarmed_tariff_item|
        begin
          tariff_item = TarmedTariffItem.new

          tariff_item.code = tarmed_tariff_item.code
          tariff_item.amount_mt = tarmed_tariff_item.amount_mt
          tariff_item.amount_tt = tarmed_tariff_item.amount_tt
          tariff_item.duration_from = tarmed_tariff_item.duration_from
          tariff_item.duration_to = tarmed_tariff_item.duration_to
          tariff_item.remark = tarmed_tariff_item.name

          tariff_item.save
          print "ID: #{tarmed_tariff_item.id} OK\n"
        rescue Exception => ex
          print "ID: #{tarmed_tariff_item.id} => #{ex.message}\n\n"
        end
      end
    end

    return TarmedTariffItem.count
  end
end
