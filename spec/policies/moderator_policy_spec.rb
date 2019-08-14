require "rails_helper"

RSpec.describe ModeratorPolicy do
  subject { described_class }

  let(:community) { create(:community) }
  let(:context) { Context.new(user, community) }
  let(:moderator) { create(:moderator, community: community) }

  context "for visitor" do
    let(:user) { nil }

    permissions :index? do
      it { is_expected.to permit(context) }
    end

    permissions :new?, :create? do
      it { is_expected.to_not permit(context) }
    end

    permissions :destroy? do
      it { is_expected.to_not permit(context, moderator) }
    end
  end

  context "for user" do
    let(:user) { create(:user) }

    permissions :index? do
      it { is_expected.to permit(context) }
    end

    permissions :new?, :create? do
      it { is_expected.to_not permit(context) }
    end

    permissions :destroy? do
      it { is_expected.to_not permit(context, moderator) }
    end
  end

  context "for moderator" do
    let(:user) { create(:moderator, community: community).user }

    permissions :index?, :new?, :create? do
      it { is_expected.to permit(context) }
    end

    permissions :destroy? do
      it { is_expected.to permit(context, moderator) }
    end
  end
end