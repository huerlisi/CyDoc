# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe Doctor do
  fixtures :doctors

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
  
  describe 'should sanitize valid ZSR:' do
    ['R777777', 'R77.7777', 'R 77.7777'
    ].each do |zsr_str|
      it zsr_str do
        @doctor = create_doctor
        @doctor.zsr = zsr_str
        @doctor.zsr.should == 'R777777'
      end
    end
  end

  describe 'should return valid name' do
    it "using login when no praxis set" do
      doctor = doctors(:test)
      doctor.name.should == doctor.login
    end
  end

  # Validations
protected
  def create_doctor(options = {})
    record = Doctor.new({ :login => 'quire' }.merge(options))
    record.save! if record.valid?
    record
  end
end
