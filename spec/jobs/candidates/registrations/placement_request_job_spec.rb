require 'rails_helper'

describe Candidates::Registrations::PlacementRequestJob, type: :job do
  include ActiveSupport::Testing::TimeHelpers
  include_context 'Stubbed candidates school'

  let :registration_store do
    Candidates::Registrations::RegistrationStore.instance
  end

  let :registration_session do
    FactoryBot.build :registration_session, urn: school.urn
  end

  let :placement_request do
    FactoryBot.build :placement_request, school: school
  end

  let :school_request_confirmation_notification do
    double NotifyEmail::SchoolRequestConfirmation, despatch!: true
  end

  let :candidate_request_confirmation_notification do
    double NotifyEmail::CandidateRequestConfirmation, despatch!: true
  end

  before do
    allow(NotifyEmail::SchoolRequestConfirmation).to \
      receive(:from_application_preview) { school_request_confirmation_notification }

    allow(NotifyEmail::CandidateRequestConfirmation).to \
      receive(:from_application_preview) { candidate_request_confirmation_notification }

    registration_store.store! registration_session

    ActiveJob::Base.queue_adapter = :inline
  end

  context '#perform' do
    context 'no errors' do
      before do
        described_class.perform_later registration_session.uuid
      end

      it 'notifies the school' do
        expect(NotifyEmail::SchoolRequestConfirmation).to \
          have_received(:from_application_preview).with \
            school.notifications_email,
            Candidates::Registrations::ApplicationPreview.new(registration_session)

        expect(school_request_confirmation_notification).to \
          have_received :despatch!
      end

      it 'notifies the candidate' do
        expect(NotifyEmail::CandidateRequestConfirmation).to \
          have_received(:from_application_preview).with \
            registration_session.email,
            Candidates::Registrations::ApplicationPreview.new(registration_session)

        expect(candidate_request_confirmation_notification).to \
          have_received :despatch!
      end

      it 'deletes the registration session from redis' do
        expect { registration_store.retrieve! registration_session.uuid }.to \
          raise_error Candidates::Registrations::RegistrationStore::SessionNotFound
      end
    end

    context 'with errors' do
      context 'non retryable' do
        let :application_job_retry_limit do
          3
        end

        before do
          allow(school_request_confirmation_notification).to receive :despatch! do
            raise 'Oh no!'
          end

          allow_any_instance_of(described_class).to receive :executions do
            application_job_retry_limit
          end
        end

        it 'lets the error propogate' do
          expect { described_class.perform_later registration_session.uuid }.to \
            raise_error RuntimeError, 'Oh no!'
        end
      end

      context 'retryable error' do
        let :number_of_executions do
          2
        end

        let :a_decent_amount_longer do
          10.minutes.from_now.to_i
        end

        before do
          allow_any_instance_of(described_class).to receive(:executions) do
            number_of_executions
          end

          allow(candidate_request_confirmation_notification).to receive :despatch! do
            raise Notify::RetryableError
          end

          allow(described_class.queue_adapter).to receive :enqueue_at

          freeze_time # so we can easily compare a decent_amount_longer from now

          described_class.perform_later registration_session.uuid
        end

        it 'reenqueues the job' do
          expect(described_class.queue_adapter).to \
            have_received(:enqueue_at).with \
              an_instance_of(described_class), a_decent_amount_longer
        end
      end
    end
  end
end
