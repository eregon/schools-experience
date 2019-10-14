Given("there are some previous bookings") do
  step "there are 3 previous bookings"
end

Then("I should see the previous bookings listed") do
  within("#bookings") do
    expect(page).to have_css('.booking', count: 3)
  end
end

And("there is/are {int} previous booking/bookings") do |count|
  now = Date.today

  travel_to 1.year.ago do
    unless @school.subjects.where(name: 'Biology').any?
      @school.subjects << FactoryBot.create(:bookings_subject, name: 'Biology')
    end
    @bookings = (1..count).map do |index|
      FactoryBot.create(
        :bookings_booking,
        :with_existing_subject,
        :accepted,
        bookings_school: @school,
        date: now - index.week
      )
    end
  end

  @booking = @bookings.first
  @booking_id = @booking.id
end

Given("there are some previous bookings belonging to other schools") do
  date = 1.week.ago.to_date

  travel_to 1.month.ago do
    @other_school_bookings = FactoryBot.create_list(:bookings_booking, 2, :accepted, date: date)
    @other_school_bookings.each do |b|
      expect(b.bookings_school).not_to eql(@school)
    end
  end
end
