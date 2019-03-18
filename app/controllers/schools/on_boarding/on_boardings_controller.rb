module Schools
  module OnBoarding
    class OnBoardingsController < BaseController
    private

      def current_school_profile
        @current_school_profile ||= get_current_school_profile
      end

      def get_current_school_profile
        Schools::SchoolProfile.find_or_create_by! urn: current_school.urn
      end

      def next_step_path(school_profile)
        public_send \
          "new_schools_on_boarding_#{CurrentStep.for(school_profile)}_path"
      end
    end
  end
end
