module CasesHelper
  def finding_css_class(finding)
    css_class = "finding_class_#{finding.code} "
    css_class += finding.finding_groups.collect { |group| "finding_group_#{group.name}" }.join(' ')
  end
end
