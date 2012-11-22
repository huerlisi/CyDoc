class DoctorsController < AuthorizedController
  # has_many :phone_numbers
  def new_phone_number
    if resource_id = params[:id]
      @doctor = Doctor.find(resource_id)
    else
      @doctor = resource_class.new
    end

    @vcard = @doctor.vcard
    @item = @vcard.contacts.build

    respond_with @item
  end
end
