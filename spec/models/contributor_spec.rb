require "rails_helper"

RSpec.describe Contributor do
  subject { described_class }

  it_behaves_like "paginatable"
end