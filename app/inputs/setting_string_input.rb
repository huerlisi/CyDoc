class SettingStringInput < SimpleForm::Inputs::Base
  def input
    @builder.fields_for :settings do |s|
      s.text_field(attribute_name, :value => object.settings[attribute_name])
    end
  end

  def label_text
    I18n.translate('activerecord.attributes.' + @builder.lookup_model_names.last + '.settings.' + attribute_name)
  end
end

