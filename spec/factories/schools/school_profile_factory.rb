FactoryBot.define do
  factory :school_profile, class: 'Schools::SchoolProfile' do
    urn { 1234567890 }

    trait :with_candidate_requirement do
      candidate_requirement_dbs_requirement { 'sometimes' }
      candidate_requirement_dbs_policy { 'Super secure' }
      candidate_requirement_requirements { true }
      candidate_requirement_requirements_details { 'Gotta go fast' }
    end

    trait :with_fees do
      fees_administration_fees { true }
      fees_dbs_fees { true }
      fees_other_fees { true }
    end

    trait :with_administration_fee do
      administration_fee_amount_pounds { 123.45 }
      administration_fee_description { 'General administration' }
      administration_fee_interval { 'Daily' }
      administration_fee_payment_method { 'Travelers Cheques' }
    end

    trait :with_dbs_fee do
      dbs_fee_amount_pounds { 200 }
      dbs_fee_description { 'DBS check' }
      dbs_fee_interval { 'One-off' }
      dbs_fee_payment_method { 'Ethereum' }
    end
  end
end
