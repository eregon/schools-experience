require 'rails_helper'

RSpec.describe "candidates/schools/index.html.erb", type: :view do
  context 'with fresh search' do
    before do
      assign(:search, Candidates::SchoolSearch.new)
      render
    end

    it "shows search form" do
      expect(rendered).to match(/Find.*placements/i)
    end
  end

  context 'filtering existing search' do
    before do
      allow(Candidates::School).to receive(:subjects).and_return(
        [[1, 'Computer science'], [2, 'Maths'], [3, 'English']]
      )

      allow(Candidates::School).to receive(:phases).and_return(
        [[1, 'Primary'], [2, 'Seconday'], [3, '16 to 18']]
      )

      @school = build(:bookings_school)
      @search = Candidates::SchoolSearch.new(
        query: 'Manchester',
        phases: %w{3},
        max_fee: '60',
        subjects: %w{1 3}
      )
      allow(@search).to receive(:results).and_return([@school])

      assign :search, @search

      render
    end

    it "shows search results" do
      expect(rendered).to match(/School experience placements near/)
      expect(rendered).to have_css '#search-results'
    end

    it "shows filled in subject filter" do
      expect(rendered).to have_css '#search-filter'
      expect(rendered).to have_checked_field 'subjects[]', count: 2
      expect(rendered).to have_unchecked_field 'subjects[]', count: 1
    end

    it "shows filled in phases filter" do
      expect(rendered).to have_css '#search-filter'
      expect(rendered).to have_checked_field 'phases[]', count: 1
      expect(rendered).to have_unchecked_field 'phases[]', count: 2
    end

    it "shows filled in max fee filter" do
      expect(rendered).to have_css '#search-filter'
      expect(rendered).to have_checked_field 'max_fee', count: 1
      expect(rendered).to have_unchecked_field 'max_fee', count: 3
    end

    it "shows results" do
      expect(rendered).to have_css 'li.school-result'
      expect(rendered).to have_css 'li.school-result>strong a', text: @school.name
      expect(rendered).to have_css 'li.school-result ul li', count: 5
    end
  end
end