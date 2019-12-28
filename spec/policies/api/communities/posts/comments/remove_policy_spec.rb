require "rails_helper"

RSpec.describe Api::Communities::Posts::Comments::RemovePolicy do
  subject { described_class }

  let(:comment) { create(:comment, community: context.community) }

  context "for visitor", context: :visitor do
    permissions :edit?, :update?, :update_reason? do
      it { is_expected.to_not permit(context, comment) }
    end
  end

  context "for user", context: :user do
    permissions :edit?, :update?, :update_reason? do
      it { is_expected.to_not permit(context, comment) }
    end
  end

  context "for moderator", context: :moderator do
    permissions :edit?, :update?, :update_reason? do
      it { is_expected.to permit(context, comment) }
    end
  end

  context "for author", context: :user do
    let(:comment) { create(:comment, user: context.user, community: context.community) }

    permissions :edit?, :update? do
      it { is_expected.to permit(context, comment) }
    end

    permissions :update_reason? do
      it { is_expected.to_not permit(context, comment) }
    end
  end

  describe ".permitted_attributes_for_update" do
    context "for moderator", context: :moderator do
      it "contains attributes" do
        comment = create(:comment, community: context.community)
        policy = described_class.new(context, comment)

        expect(policy.permitted_attributes_for_update).to contain_exactly(:reason)
      end
    end

    context "for author", context: :user do
      it "does not contain attributes" do
        comment = create(:comment, community: context.community, user: context.user)
        policy = described_class.new(context, comment)

        expect(policy.permitted_attributes_for_update).to be_blank
      end
    end
  end
end
