class SettingSelectInput < SimpleForm::Inputs::CollectionInput
  def input
    @builder.fields_for :settings do |s|
      s.select(attribute_name, collection, :selected => object.settings[attribute_name])
    end
  end

  def label_text
    I18n.translate('activerecord.attributes.' + @builder.lookup_model_names.last + '.settings.' + attribute_name)
  end
end

