require "rails_helper"

RSpec.describe HomePolicy do
  subject { described_class }

  let(:context) { Context.new(user) }

  context "for visitor" do
    let(:user) { nil }

    permissions :index? do
      it { is_expected.to permit(context) }
    end
  end

  context "for user" do
    let(:user) { create(:user) }

    permissions :index? do
      it { is_expected.to permit(context) }
    end
  end
end