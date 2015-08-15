require 'rails_helper'

RSpec.describe Dentist, type: :model do
  before { @dentist = FactoryGirl.build(:dentist) }

  subject { @dentist }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@domain.com').for(:email) }
end
