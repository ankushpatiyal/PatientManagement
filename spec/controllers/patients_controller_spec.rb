require 'rails_helper'
require 'debug'

RSpec.describe PatientsController, type: :request do
  describe 'patients' do
    context "index" do
      let!(:patient1) {create(:patient, name: "xyx", next_appointment: DateTime.now + 1.hour)}
      let!(:patient2) {create(:patient, name: "hello", next_appointment: DateTime.now - 1.hour)}
      let!(:patient3) {create(:patient, name: "awesome", next_appointment: DateTime.now - 1.hour)}

      context "when filters are passed" do
        before { get '/patients' }

        context "when query parameter is passed" do
          it "should call filter_by_name_email_or_all" do
            expect(response).to have_http_status(:ok)

            expect(assigns(:patients)).to eq([patient1, patient2, patient3])
          end
        end

        context "when upcoming parameter is passed" do
          before { get '/patients?upcoming=true' }

          it "should call fetch_upcoming_patients" do
            expect(response).to have_http_status(:ok)

            expect(assigns(:patients)).to eq([patient1])
          end
        end
      end

      context "when filters are not passed" do
        before { get '/patients?query=wes' }

        it "should call filter_by_name_email_or_all" do
          expect(response).to have_http_status(:ok)

            expect(assigns(:patients)).to eq([patient3])
        end
      end
    end
  end
end
