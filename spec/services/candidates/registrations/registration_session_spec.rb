require 'rails_helper'

describe Candidates::Registrations::RegistrationSession do
  let! :date do
    DateTime.now
  end

  before do
    allow(DateTime).to receive(:now) { date }
  end

  context '#initialize' do
    before do
      described_class.new session
    end

    context 'when registration key is not set' do
      let :session do
        {}
      end

      it 'adds the registration key to the session' do
        expect(session).to eq({})
      end
    end

    context 'when registration key is set' do
      let :session do
        { 'some' => 'information' }
      end

      it "doesn't over write the registration key" do
        expect(session).to eq 'some' => 'information'
      end
    end
  end

  context '#save' do
    let :session do
      { 'some' => 'information' }
    end

    let :model do
      Candidates::Registrations::BackgroundCheck.new has_dbs_check: true
    end

    before do
      described_class.new(session).save model
    end

    it 'stores the models attributes under the correct key' do
      expect(
        session
      ).to eq \
        'has_dbs_check' => true,
        'background_check_created_at' => date,
        'background_check_updated_at' => date,
        'some' => 'information'
    end

    it 'doesnt over write other keys' do
      expect(session['some']).to eq 'information'
    end
  end

  context '#uuid' do
    before do
      allow(SecureRandom).to receive(:urlsafe_base64) { 'sekret' }
    end

    context 'when uuid not already set' do
      it 'generates and returns a new uuid' do
        expect(described_class.new({}).uuid).to eq 'sekret'
      end
    end

    context 'when uuid is already set' do
      it 'returns the existing uuid' do
        expect(described_class.new('uuid' => '17').uuid).to eq '17'
      end
    end
  end

  context '#education_attributes' do
    context 'when education is not in session' do
      subject { described_class.new({}) }

      it 'returns an empty hash' do
        expect(subject.education_attributes).to eq({})
      end
    end

    context 'when education is in session' do
      # TODO open ticket to remove
      context 'when legacy session' do
        subject { FactoryBot.build :registration_session, :with_education }

        it 'returns the correct attributes' do
          expect(subject.education_attributes.except('created_at', 'updated_at')).to eq \
            FactoryBot.attributes_for(:education).stringify_keys
        end
      end

      context 'when new session' do
        subject { FactoryBot.build :new_registration_session, :with_education }

        it 'returns the correct attributes' do
          expect(subject.education_attributes.except('created_at', 'updated_at')).to eq \
            FactoryBot.attributes_for(:education).stringify_keys
        end
      end
    end
  end

  context '#education' do
    context 'when not education in session' do
      subject { described_class.new({}) }

      it 'raise StepNotFound' do
        expect { subject.education }.to raise_error described_class::StepNotFound
      end
    end

    context 'when education in session' do
      # TODO open ticket to remove
      context 'when legacy session' do
        let :session do
          FactoryBot.build :registration_session, :with_education
        end

        subject { session.education }

        it { is_expected.to be_a Candidates::Registrations::Education }
        it do
          expect(subject.attributes.except('created_at', 'updated_at')).to \
            eq FactoryBot.build(:education).attributes.except('created_at', 'updated_at')
        end
      end

      context 'when new session' do
        let :session do
          FactoryBot.build :new_registration_session, :with_education
        end

        subject { session.education }

        it { is_expected.to be_a Candidates::Registrations::Education }
        it do
          expect(subject.attributes.except('created_at', 'updated_at')).to \
            eq FactoryBot.build(:education).attributes.except('created_at', 'updated_at')
        end
      end
    end
  end

  context '#teaching_preference_attributes' do
    context 'when teaching_preference is not in session' do
      subject { described_class.new({}) }

      it 'returns an empty hash' do
        expect(subject.teaching_preference_attributes).to eq({})
      end
    end

    context 'when teaching_preference is in session' do
      # TODO open ticket to remove
      context 'when legacy session' do
        subject { FactoryBot.build :registration_session, :with_teaching_preference }

        it 'returns the correct attributes' do
          expect(subject.teaching_preference_attributes.except('created_at', 'updated_at')).to eq \
            FactoryBot.attributes_for(:teaching_preference).stringify_keys
        end
      end

      context 'when new session' do
        subject { FactoryBot.build :new_registration_session, :with_teaching_preference }

        it 'returns the correct attributes' do
          expect(subject.teaching_preference_attributes.except('created_at', 'updated_at')).to eq \
            FactoryBot.attributes_for(:teaching_preference).stringify_keys
        end
      end
    end
  end

  context '#teaching_preference' do
    context 'when teaching_preference is not in the session' do
      subject { described_class.new({}) }

      it 'raises StepNotFound' do
        expect { subject.teaching_preference }.to raise_error described_class::StepNotFound
      end
    end

    context 'when teaching_preference is in the session' do
      # TODO open ticket to remove
      context 'when legacy session' do
        let :session do
          FactoryBot.build \
            :registration_session, :with_teaching_preference, :with_school
        end

        subject { session.teaching_preference }

        it { is_expected.to be_a Candidates::Registrations::TeachingPreference }

        it do
          expect(subject.attributes.except('created_at', 'updated_at')).to \
            eq FactoryBot.build(:teaching_preference).attributes.except('created_at', 'updated_at')
        end

        it 'sets the school correctly' do
          expect(subject.school).to eq session.school
        end
      end

      context 'when new session' do
        let :session do
          FactoryBot.build \
            :new_registration_session, :with_teaching_preference, :with_school
        end

        subject { session.teaching_preference }

        it { is_expected.to be_a Candidates::Registrations::TeachingPreference }

        it do
          expect(subject.attributes.except('created_at', 'updated_at')).to \
            eq FactoryBot.build(:teaching_preference).attributes.except('created_at', 'updated_at')
        end

        it 'sets the school correctly' do
          expect(subject.school).to eq session.school
        end
      end
    end
  end

  context '#pending_email_confirmation?' do
    context 'when not pending email confirmation' do
      it 'returns false' do
        expect(described_class.new({})).not_to be_pending_email_confirmation
      end
    end

    context 'when pending email confirmation' do
      it 'returns true' do
        expect(
          described_class.new('status' => 'pending_email_confirmation')
        ).to be_pending_email_confirmation
      end
    end
  end

  context '#flag_as_pending_email_confirmation!' do
    context 'when registration is not complete' do
      subject do
        described_class.new({})
      end

      it 'raises an error' do
        expect { subject.flag_as_pending_email_confirmation! }.to \
          raise_error described_class::NotCompletedError
      end

      it "doesn't mark the session as pending_email_confirmation" do
        expect(subject).not_to be_pending_email_confirmation
      end
    end

    context 'when registration is complete' do
      include_context 'Stubbed candidates school'

      # TODO open ticket to remove
      context 'when legacy session' do
        subject do
          FactoryBot.build :new_registration_session
        end

        before do
          subject.flag_as_pending_email_confirmation!
        end

        it 'marks the session as pending_email_confirmation' do
          expect(subject).to be_pending_email_confirmation
        end
      end

      context 'when new session' do
        subject do
          FactoryBot.build :new_registration_session
        end

        before do
          subject.flag_as_pending_email_confirmation!
        end

        it 'marks the session as pending_email_confirmation' do
          expect(subject).to be_pending_email_confirmation
        end
      end
    end
  end

  context '#fetch' do
    let :session do
      {
        'candidates_registrations_background_check' => {
          'has_dbs_check' => true
        }
      }
    end

    let :model_klass do
      Candidates::Registrations::BackgroundCheck
    end

    let :returned_model do
      described_class.new(session).fetch model_klass
    end

    it 'instantiates and returns the model correctly' do
      expect(returned_model).to be_a model_klass
      expect(returned_model.has_dbs_check).to be true
    end
  end

  context '#completed?' do
    context 'not completed' do
      let :session do
        {}
      end

      it 'returns false' do
        expect(described_class.new(session).completed?).to be false
      end
    end

    context 'completed' do
      let :session do
        { 'status' => 'completed' }
      end

      it 'returns true' do
        expect(described_class.new(session).completed?).to be true
      end
    end
  end

  context '#flag_as_completed!' do
    include_context 'Stubbed candidates school'

    # TODO open ticket to remove
    context 'when legacy session' do
      let :registration_session do
        FactoryBot.build :new_registration_session
      end

      before do
        registration_session.flag_as_completed!
      end

      it 'marks the registration_session as completed' do
        expect(registration_session).to be_completed
      end
    end

    context 'when new session' do
      let :registration_session do
        FactoryBot.build :new_registration_session
      end

      before do
        registration_session.flag_as_completed!
      end

      it 'marks the registration_session as completed' do
        expect(registration_session).to be_completed
      end
    end
  end
end
