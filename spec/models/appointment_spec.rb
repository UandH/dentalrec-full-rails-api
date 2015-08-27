require 'rails_helper'

RSpec.describe Appointment, type: :model do
  let(:appointment) { FactoryGirl.build :appointment }
  subject { appointment }

  it { should respond_to(:date) }
  it { should respond_to(:symptoms) }
  it { should respond_to(:dentist_id) }

  it { should validate_presence_of :date }
  it { should validate_presence_of :symptoms }
  it { should validate_presence_of :dentist_id }

  it { should belong_to :dentist }

  describe '.recent' do
    before(:each) do
      @appointment1 = FactoryGirl.create :appointment, date: '2015-04-03'
      @appointment2 = FactoryGirl.create :appointment, date: '2015-06-11'
      @appointment3 = FactoryGirl.create :appointment, date: '2015-02-10'
      @appointment4 = FactoryGirl.create :appointment, date: '2015-01-24'
    end

    it 'returns the recent scheduled appointments' do
      expect(Appointment.recent).to match_array([@appointment2, @appointment3, @appointment1, @appointment4])
    end
  end

end
