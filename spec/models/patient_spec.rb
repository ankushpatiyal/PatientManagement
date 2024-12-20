require 'rails_helper'
require 'debug'

RSpec.describe Patient, type: :model do
  let(:patient1) { create(:patient, email: "sdf@gmail.com") }

  context "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:date_of_birth) }

    it 'should validate date of birth' do
      patient1.date_of_birth = "324"
      patient1.valid?

      expect(patient1.errors.full_messages).to match_array([ "Date of birth can't be blank", "Date of birth must be in the format YYYY-MM-DD" ])
    end

    it 'should validate email' do
      patient2 = build(:patient)
      patient2.email = "asdfkj@"
      patient2.valid?

      expect(patient2.errors.full_messages).to match_array([ "Email invalid email format" ])
    end
  end

  context "scopes" do
    context "fetch_upcoming_patients" do
      context "when patients have next appointments is within 72 hours" do
        let!(:patient1) { create(:patient, next_appointment: DateTime.now+1.hour) }
        let!(:patient2) { create(:patient, next_appointment: DateTime.now-10.hour) }
        let!(:patient3) { create(:patient, next_appointment: DateTime.now+71.hour) }

        it "should return correct data" do
          rs = Patient.fetch_upcoming_patients

          expect(rs.ids).to match_array([ patient1.id, patient3.id ])
        end
      end

      context "when there are no patients that have next appointments within 72 hours" do
        let!(:patient1) { create(:patient, next_appointment: DateTime.now-10.hour) }
        let!(:patient2) { create(:patient, next_appointment: DateTime.now-20.hour) }
        it "should return empty data" do
          rs = Patient.fetch_upcoming_patients

          expect(rs).to be_empty
        end
      end

      context "when there are no patients" do
        it "should return empty data" do
          rs = Patient.fetch_upcoming_patients

          expect(rs).to be_empty
        end
      end
    end
  end

  context ".filter_by_name_email_or_all" do
    let!(:patient1) { create(:patient, name: "batman", email: "awesome@gmail.com") }
    let!(:patient2) { create(:patient, name: "superman", email: "italy@gmail.com") }

    context "when blank string is passed" do
      it "should return all records" do
        rs = Patient.filter_by_name_email_or_all

        expect(rs.ids).to match_array([ patient1.id, patient2.id ])
      end
    end

    context "filter by name" do
      context "when username is present in records" do
        it "should return correct records" do
          rs = Patient.filter_by_name_email_or_all("bat")

          expect(rs.ids).to match_array([ patient1.id ])
        end
      end

      context "when username is not present in records" do
        it "should return empty records" do
          rs = Patient.filter_by_name_email_or_all("uuuuuu")

          expect(rs).to be_empty
        end
      end
    end

    context "filter by email" do
      context "when email is present in records" do
        it "should return correct records" do
          rs = Patient.filter_by_name_email_or_all("ita")

          expect(rs.ids).to match_array([ patient2.id ])
        end
      end

      context "when email is not present in records" do
        it "should return empty records" do
          rs = Patient.filter_by_name_email_or_all("ioioioi")

          expect(rs).to be_empty
        end
      end
    end
  end
end
