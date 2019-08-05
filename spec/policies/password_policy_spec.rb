require "rails_helper"

RSpec.describe PasswordPolicy do
  subject { described_class }

  let(:context) { Context.new(user) }

  context "for visitor" do
    let(:user) { nil }

    permissions :edit?, :update? do
      it { is_expected.to permit(context) }
    end
  end

  context "for user" do
    let(:user) { create(:user) }

    permissions :edit?, :update? do
      it { is_expected.to permit(context) }
    end
  end
end