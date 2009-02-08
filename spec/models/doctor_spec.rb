require File.dirname(__FILE__) + '/../spec_helper'

describe Doctor do
  describe 'being created' do
    before do
      @doctor = nil
      @creating_doctor = lambda do
        @doctor = create_doctor
        violated "#{@doctor.errors.full_messages.to_sentence}" if @doctor.new_record?
      end
    end

    it 'increments Doctor#count' do
      @creating_doctor.should change(Doctor, :count).by(1)
    end

    it 'starts in active state' do
      @creating_doctor.call
      @doctor.reload
      @doctor.should be_active
    end
  end

  # Validations
protected
  def create_doctor(options = {})
    record = Doctor.new({ :login => 'quire', :password => 'quire69' }.merge(options))
    record.save! if record.valid?
    record
  end
end
