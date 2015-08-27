require 'rails_helper'

RSpec.describe Dentist, type: :model do
  before { @dentist = FactoryGirl.build(:dentist) }

  subject { @dentist }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }

  it { should be_valid }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_confirmation_of(:password) }
  it { should allow_value('example@domain.com').for(:email) }
  # we test the auth_token is unique
  it { should validate_uniqueness_of(:auth_token) }

  it { should have_many (:appointments) }

  describe '#appointments association' do
    before do
      @dentist.save
      3.times { FactoryGirl.create :appointment, dentist: @dentist }
    end

    it 'destroys the associated products on self destruct' do
      appointments = @dentist.appointments
      @dentist.destroy
      appointments.each do |appointment|
        expect(Appointment.find(appointment)).to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe '#generate_authentication_token!' do
    it 'generates a unique token' do
      # Devise.stub(:friendly_token).and_return("auniquetoken123")
      allow(Devise).to receive(:friendly_token).and_return('auniquetoken123')
      @dentist.generate_authentication_token!
      expect(@dentist.auth_token).to eql 'auniquetoken123'
    end

    it 'generates another token when one already has been taken' do
      existing_dentist = FactoryGirl.create(:dentist, auth_token: 'auniquetoken123')
      @dentist.generate_authentication_token!
      expect(@dentist.auth_token).not_to eql existing_dentist.auth_token
    end
  end

  describe '.filter_by_email' do
    before(:each) do
      @dentist1 = FactoryGirl.create :dentist, email: 'dramikas@gmail.com'
      @dentist2 = FactoryGirl.create :dentist, email: 'ljubabuba@gmail.com'
      @dentist3 = FactoryGirl.create :dentist, email: 'nele@gyahoo.com'
      @dentist4 = FactoryGirl.create :dentist, email: 'sele@yahoo.com'
    end

    context "when email is 'not_exist@gmail.com'" do
      it 'returns an empty array' do
        expect(Dentist.filter_by_email('not_exist@gmail.com')).to be_empty
      end
    end

    context "when email has 'gmail'" do
      it 'returns the dentists matching' do
        expect(Dentist.filter_by_email('gmail').sort).to match_array([@dentist1, @dentist2])
      end
    end
  end

  describe '.search' do
    before(:each) do
      @dentist1 = FactoryGirl.create :dentist, email: 'dramikas@gmail.com'
      @dentist2 = FactoryGirl.create :dentist, email: 'ljubabuba@gmail.com'
      @dentist3 = FactoryGirl.create :dentist, email: 'nele@gyahoo.com'
      @dentist4 = FactoryGirl.create :dentist, email: 'sele@yahoo.com'
    end

    context "when email has 'gmail'" do
      it 'returns the dentists matching' do
        search_hash = {email: 'gmail'}
        expect(Dentist.search(search_hash).sort).to match_array([@dentist1, @dentist2])
      end
    end
  end

end
