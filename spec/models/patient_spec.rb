# -*- encoding : utf-8 -*-
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
      @patient.should be_active
    end

    it 'takes some arguments' do
      @patient = create_patient(
        :birth_date => '1998-02-05',
        :sex => 2,
        :remarks => 'Just a simple test patient. Äuä scho no öppis!!!',
        :doctor_patient_nr => 'a777.7',
        :name => 'Ursina Wiederkehr'
      )
      @patient.birth_date.should == Date.parse('1998-02-05')
      @patient.sex.should == 'F'
      @patient.doctor_patient_nr == 'a777.7'
      @patient.name == 'Ursina Wiederkehr'
    end

    it 'should have sane defaults' do
      @patient = create_patient
      @patient.stub!(:find).and_return @patient
      @patient.reload
      @patient.should_not be_dunning_stop
      @patient.should_not be_use_billing_address
      @patient.should_not be_deceased
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
