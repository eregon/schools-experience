require 'rails_helper'

describe Bookings::Gitis::CRM, type: :model do
  let(:gitis) { described_class.new('a-token') }

  describe '.initialize' do
    it "will succeed with access token" do
      expect(described_class.new('something')).to \
        be_instance_of(Bookings::Gitis::CRM)
    end

    it "will raise an exception without an access token" do
      expect { subject }.to raise_exception(ArgumentError)
    end
  end

  describe '.find' do
    context 'with no account_ids' do
      it "will raise an exception" do
        expect {
          gitis.find
        }.to raise_exception(ArgumentError)
      end
    end

    context 'with single account_ids' do
      before { @contacts = gitis.find(1) }

      it "will return a single account" do
        expect(@contacts).to be_instance_of Bookings::Gitis::Contact
      end
    end

    context 'with multiple account_ids' do
      before { @contacts = gitis.find(1, 2, 3) }

      it "will return an account per id" do
        expect(@contacts.length).to eq(3)
        expect(@contacts).to all be_instance_of(Bookings::Gitis::Contact)
      end
    end

    context 'with array of account_ids' do
      before { @contacts = gitis.find([1, 2, 3]) }

      it "will return an account per id" do
        expect(@contacts.length).to eq(3)
        expect(@contacts).to all be_instance_of(Bookings::Gitis::Contact)
      end
    end
  end

  describe '.find_by_email' do
    let(:email) { 'me@something.com' }

    it "will return a contact record" do
      expect(gitis.find_by_email(email).email).to eq(email)
    end
  end

  describe '.write' do
    # Note: this is just stubbed functionality for now
    context 'with a valid contact' do
      before { @contact = build(:gitis_contact) }

      it "will succeed" do
        expect(gitis.write(@contact)).to eq(1)
      end
    end

    context 'without a contact' do
      it "will raise an exception" do
        expect {
          gitis.write(OpenStruct.new)
        }.to raise_exception(ArgumentError)
      end
    end

    context 'with an invalid contact' do
      before do
        @contact = build(:gitis_contact, email: '')
      end

      it "will return false" do
        expect(gitis.write(@contact)).to be false
      end
    end
  end
end