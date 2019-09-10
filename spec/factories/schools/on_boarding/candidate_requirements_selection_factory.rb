FactoryBot.define do
  factory :candidate_requirements_selection, class: Schools::OnBoarding::CandidateRequirementsSelection do
    on_teacher_training_course { true }
    not_on_another_training_course { false }
    has_or_working_towards_degree { true }
    live_locally { true }
    maximum_distance_from_school { 8 }
    other { true }
    other_details { 'Some other requirements' }
  end
end