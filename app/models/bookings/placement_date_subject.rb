class Bookings::PlacementDateSubject < ApplicationRecord
  belongs_to :bookings_placement_date, class_name: 'Bookings::PlacementDate'
  belongs_to :bookings_subject, class_name: 'Bookings::Subject'

  validates :bookings_placement_date, presence: true
  validates :bookings_subject, presence: true

  validates :bookings_subject_id,
    inclusion: { in: :allowed_subject_choices },
    if: :bookings_subject_id

  # this combined id is used when candidates are choosing a subject specific
  # date and are presented with a single list of options that contain
  # placement dates and subjects
  def date_and_subject_id
    [bookings_placement_date.id, bookings_subject_id].join("_")
  end

private

  def allowed_subject_choices
    bookings_placement_date.bookings_school.subject_ids
  end
end
