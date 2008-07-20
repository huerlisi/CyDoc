class ZytolaborCase < MedicalCase
  belongs_to :zytolabor_case, :class_name => 'Case'
end
