module Candidates
  module Registrations
    class ConfirmationEmailsController < RegistrationsController
      def show
        @email = current_registration.email
        @school_name = current_registration.school.name
        @resend_link = candidates_school_registrations_resend_confirmation_email_path
      end

      def create
        @privacy_policy = PrivacyPolicy.new privacy_policy_params

        if @privacy_policy.not_accepted?
          @application_preview = ApplicationPreview.new current_registration
          render 'candidates/registrations/application_previews/show'
        elsif candidate_signed_in?
          RegistrationStore.instance.store! current_registration
          redirect_to candidates_confirm_path uuid: current_registration.uuid
        else
          current_registration.flag_as_pending_email_confirmation!
          RegistrationStore.instance.store! current_registration

          SendEmailConfirmationJob.perform_later \
            current_registration.uuid,
            request.host

          redirect_to candidates_school_registrations_confirmation_email_path
        end
      rescue RegistrationSession::NotCompletedError
        # We can get here if the school changes their date format while the
        # candidate is applying, or we push a code change mid way through a
        # registration.
        redirect_to next_step_path(current_registration)
      end

    private

      def privacy_policy_params
        params.require(:candidates_registrations_privacy_policy).permit \
          :acceptance
      end
    end
  end
end
