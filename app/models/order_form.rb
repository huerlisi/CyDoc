class OrderForm < ActiveRecord::Base
  file_column :file, :magick => {
    :versions => {
      :full => {:size => "550"},
      :address => {:transformation => Proc.new { |image| image.crop(::Magick::NorthWestGravity, image.rows, image.columns * 0.5, true) }, :size => "560"},
      :remarks => {:transformation => :extract_remarks },
      :result_remarks => {:transformation => :extract_result_remarks, :size => "620"},
      :overview => {:transformation => Proc.new { |image| image.crop(::Magick::NorthWestGravity, 0, 75, 1155, 360, true) } },
      :head => {:transformation => Proc.new { |image| image.crop(::Magick::NorthWestGravity, 0, 0, 1172, 586, true) }, :size => "500" },
      :head_big => {:transformation => Proc.new { |image| image.crop(::Magick::NorthWestGravity, 0, 0, 1172, 586, true) }, :size => "750" },
      :foot => {:transformation => Proc.new { |image| image.crop(::Magick::NorthWestGravity, 0, 1137, 1172, 469, true) }, :size => "500" }
    }
  }
end
