require "rails_helper"

RSpec.describe SignOutPolicy do
  subject { described_class }

  let(:context) { Context.new(user) }

  context "for visitor" do
    let(:user) { nil }

    permissions :destroy? do
      it { is_expected.to_not permit(context) }
    end
  end

  context "for user" do
    let(:user) { create(:user) }

    permissions :destroy? do
      it { is_expected.to permit(context) }
    end
  end
end