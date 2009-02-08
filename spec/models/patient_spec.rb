require File.dirname(__FILE__) + '/../spec_helper'

describe Patient do
  describe 'being created' do
    before do
      @patient = nil
      @creating_patient = lambda do
        @patient = create_patient
        violated "#{@patient.errors.full_messages.to_sentence}" if @patient.new_record?
      end
    end

    it 'increments Patient#count' do
      @creating_patient.should change(Patient, :count).by(1)
    end

    it 'starts in active state' do
      @creating_patient.call
      @patient.reload
      @patient.should be_active
    end
  end

  # Validations
protected
  def create_patient(options = {})
    record = Patient.new({ }.merge(options))
    record.save! if record.valid?
    record
  end
end
