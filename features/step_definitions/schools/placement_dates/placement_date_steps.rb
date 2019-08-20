Given "I have entered a placement date" do
  steps %Q(
    Given I am on the 'new placement date' page
    And I fill in the form with a future date and duration of 3
    And I submit the form
  )
end

Given "the placement date is subject specific" do
  steps %Q(
    Given I choose 'No' from the "Is there a maximum number of bookings you’ll accept for this date?" radio buttons
    And I choose 'No' from the "Is this date available for all the subjects you offer?" radio buttons
    And I submit the form
  )
end

Then "the page's main heading should be the date I just entered" do
  date = @school.bookings_placement_dates.last
  expected_title = "#{date.date.to_formatted_s(:govuk)} (#{date.duration} days)"
  expect(page).to have_css 'h1', text: expected_title
end

Then "there should be a {string} number field" do |string|
  expect(page).to have_field(string, type: 'number')
end

Then "I should be on the new subject selection page for this date" do
  expect(page.current_path).to eq \
    path_for('new subject selection', placement_date_id: @school.bookings_placement_dates.last.id)
end

Then "I should see a list of subjects the school offers" do
  @school.subjects.each do |subject|
    expect(page).to have_field(subject.name, type: 'checkbox')
  end
end

Then "an option to select all subjects" do
  expect(page).to have_field('All subjects', type: 'checkbox')
end

Then "my date should be listed" do
  date = @school.bookings_placement_dates.last

  expect(page).to have_text date.date.to_formatted_s(:govuk)
  expect(page).to have_text("#{date.duration} " + 'day'.pluralize(date.duration))
  expect(page).to have_text date.date.to_formatted_s(:govuk)

  if date.subjects == @school.subjects
    expect(page).to have_text 'All subjects'
  else
    date.subjects.map(&:name).each { |name| expect(page).to have_text name }
  end
end