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

  it { should belong_to :dentist}
end
