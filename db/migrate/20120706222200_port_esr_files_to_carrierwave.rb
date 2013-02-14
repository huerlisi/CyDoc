# -*- encoding : utf-8 -*-
class PortEsrFilesToCarrierwave < ActiveRecord::Migration
  def self.up
    rename_column :esr_files, :filename, :file
    remove_column :esr_files, :content_type
    remove_column :esr_files, :size

    old_dir = Rails.root.join('public', 'esr_files')
    new_base = Rails.root.join('uploads', 'esr_files')
    FileUtils.mkdir_p(new_base)
    new_dir = new_base.join('file')
    FileUtils.mkdir_p(new_dir)

    old_paths = Dir.glob(old_dir.join('*/*'))
    old_paths.each do |path|
      id = path.gsub(old_dir, '').gsub(/^[#{File::SEPARATOR}0]*/, '')
      File.rename(path, new_dir.join(id))
    end
  end

  def self.down
    add_column :esr_files, :size, :integer
    add_column :esr_files, :content_type, :string
    rename_column :esr_files, :file, :filename
  end
end
