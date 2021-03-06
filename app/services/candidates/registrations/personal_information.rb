module Candidates
  module Registrations
    class PersonalInformation < RegistrationStep
      # multi parameter date fields aren't yet support by ActiveModel so we
      # need to include the support for them from ActiveRecord
      include ActiveRecord::AttributeAssignment

      MIN_AGE = 18
      MAX_AGE = 100

      attribute :first_name
      attribute :last_name
      attribute :email
      attribute :date_of_birth, :date
      attribute :read_only, :boolean, default: false

      validates :first_name, presence: true, length: { maximum: 50 }, unless: :read_only
      validates :last_name, presence: true, length: { maximum: 50 }, unless: :read_only
      validates :email, presence: true, length: { maximum: 100 }
      validates :email, email_format: true, if: -> { email.present? }
      validates :date_of_birth, presence: true, unless: :read_only
      validates :date_of_birth,
        timeliness: {
          on_or_before: MIN_AGE.years.ago,
          on_or_after: MAX_AGE.years.ago
        },
        if: -> { date_of_birth.present? && !read_only }

      def full_name
        return nil unless first_name && last_name

        [first_name, last_name].map(&:presence).join(' ')
      end

      def create_signin_token(gitis_crm)
        build_candidate_session(gitis_crm).create_signin_token
      end

      def first_name=(*args)
        read_only ? first_name : super
      end

      def last_name=(*args)
        read_only ? last_name : super
      end

      def email=(*args)
        if read_only
          email
        elsif args.empty? || args.first.nil?
          super
        else
          super(*([args.shift.to_s.strip] + args))
        end
      end

      # Rescue argument error thrown by
      # validates_timeliness/extensions/multiparameter_handler.rb
      # when the user enters a DOB like `-1, -1, -2`.
      # date of birth will be unset and get caught by the presence validation
      def date_of_birth=(*args)
        read_only ? date_of_birth : super
      rescue ArgumentError
        nil
      end

    private

      def build_candidate_session(gitis_crm)
        Candidates::Session.new(
          gitis_crm,
          firstname: first_name,
          lastname: last_name,
          email: email,
          date_of_birth: date_of_birth
        )
      end
    end
  end
end
