require 'rails_helper'

describe ServiceUpdate, type: :model do
  let :attrs do
    {
      date: '20200601',
      title: 'Service Update A',
      summary: 'This is a short summary of Update A',
      content: "This is the full description of Update A.\n\nWith a longer explanation",
    }
  end

  describe 'attributes' do
    subject { described_class.new attrs }

    it { is_expected.to have_attributes date: Date.parse(attrs[:date]) }
    it { is_expected.to have_attributes title: attrs[:title] }
    it { is_expected.to have_attributes summary: attrs[:summary] }
    it { is_expected.to have_attributes content: attrs[:content] }
  end

  context 'with stub data' do
    let(:stub_dates) { %w(20010201 20200202 20200203) }
    before { allow(described_class).to receive(:keys) { stub_dates } }

    describe '.dates' do
      subject { described_class.dates }
      it { is_expected.to eql stub_dates }
    end

    describe '.latest_date' do
      subject { described_class.latest_date }
      it { is_expected.to eql '20200203' }
    end

    describe '.latest' do
      before do
        allow(described_class).to receive(:find).with(stub_dates.last) \
          { |key| described_class.new attrs.merge date: key }

        allow(described_class).to receive(:latest_date) { stub_dates.last }
      end

      subject! { described_class.latest }
      it { is_expected.to have_attributes date: Date.parse(stub_dates.last) }
      it { expect(described_class).to have_received(:latest_date) }
      it { expect(described_class).to have_received(:find).with(stub_dates.last) }
    end
  end
end
