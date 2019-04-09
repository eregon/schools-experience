require 'rails_helper'
require_relative 'session_context'

describe Schools::DashboardsController, type: :request do
  context '#show' do
    context 'when a school exists' do
      let!(:school) do
        FactoryBot.create(:bookings_school, name: 'organisation one', urn: '356127')
      end

      context 'when logged in' do
        include_context "logged in DfE user"

        subject! { get '/schools/dashboard' }

        it 'sets the correct school' do
          expect(assigns(:school)).to eq(school)
        end

        it 'renders the show template' do
          expect(response).to render_template :show
        end
      end

      context 'when not logged in' do
        subject { get '/schools/dashboard' }
        it_behaves_like "a protected page"
      end
    end

    context "when the school doesn't exist" do
      include_context "logged in DfE user"
      subject { get '/schools/dashboard' }

      before do
        @current_user_school.destroy!
      end

      specify 'should redirect to school not registered error page' do
        expect(subject).to redirect_to(schools_errors_not_registered_path)
      end
    end

    context "when the urn isn't present in the session" do
      include_context "logged in DfE user"
      before do
        get '/'
        request.session[:urn] = nil
        get '/schools/dashboard'
      end

      specify 'should redirect to school not registered error page' do
        expect(subject).to redirect_to(schools_errors_no_school_path)
      end
    end
  end
end
