module Candidates
  module Registrations
    class BackgroundChecksController < RegistrationsController
      def new
        @background_check = \
          current_registration.build_background_check attributes_from_session
      end

      def create
        @background_check = \
          current_registration.build_background_check background_check_params

        if @background_check.save
          redirect_to next_step_path
        else
          render :new
        end
      end

      def edit
        @background_check = current_registration.background_check
      end

      def update
        @background_check = current_registration.background_check

        if @background_check.update background_check_params
          redirect_to candidates_school_registrations_application_preview_path
        else
          render :edit
        end
      end

    private

      def background_check_params
        params.require(:candidates_registrations_background_check).permit \
          :has_dbs_check
      end

      def attributes_from_session
        current_registration.background_check_attributes.except 'created_at'
      end
    end
  end
end
