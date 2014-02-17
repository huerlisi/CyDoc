# -*- encoding : utf-8 -*-
class SettingBooleanInput < SimpleForm::Inputs::BooleanInput
  def input
    @builder.template.hidden_field_tag("#{object_name}[settings][#{attribute_name}]", "0") +
    @builder.template.check_box_tag("#{object_name}[settings][#{attribute_name}]", "1", object.settings[attribute_name] == "1")
  end

  def label_text
    I18n.translate('activerecord.attributes.' + @builder.lookup_model_names.last + '.settings.' + attribute_name)
  end
end
