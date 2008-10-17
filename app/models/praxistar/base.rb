include Praxistar

class Praxistar::Base < ActiveRecord::Base
  require 'yaml'
  
  praxistar_connection = YAML.load(File.open(File.join(RAILS_ROOT,"config/database.yml"),"r"))["praxis_" + ( ENV['RAILS_ENV'] || 'development' )]
  
  establish_connection(praxistar_connection)

  def self.export(record_id = :all)
    last_export = Exports.find(:first, :conditions => "model = '#{self.name}'", :order => "finished_at DESC")
    
    find_params = {
      :conditions => [ "updated_at >= ?", last_export.started_at ]
    } unless last_export.nil?
    
    export = Exports.new(:started_at => Time.now, :find_params => find_params, :model => self.name)

    if record_id == :all
    	records = hozr_model.find(:all, find_params)
    else
    	records = [hozr_model.find(record_id)]
    end
    
    export.record_count = records.size
    export.error_ids = 'none'
    export.save
    
    for h in records
      begin
        if exists?(h.id)
          attributes = export_attributes(h, false)
          update(h.id, attributes)
          export.update_count += 1
        else
          attributes = export_attributes(h, true)
          p = new(attributes)
          p.id = h.id
          p.save
          export.create_count += 1
        end
          export.save
      
      rescue Exception => ex
	if export.error_ids.nil?
		export.error_ids = h.id.to_s
	else
		export.error_ids += ", #{h.id}"
	end
        export.error_count += 1
        export.save
        
        print "Error #{self.name}(#{h.id}): #{ex.message}\n"
        h.logger.warn "Error #{self.name}(#{h.id}): #{ex.message}\n"
        h.logger.warn ex.backtrace.join("\n\t")
        h.logger.warn "\n"
      end
    end
  
    export.finished_at = Time.now
    export.save
  
    logger.warn(export.attributes.to_yaml)
    return export
  end
end
