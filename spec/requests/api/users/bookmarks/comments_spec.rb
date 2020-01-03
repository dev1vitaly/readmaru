require "rails_helper"

RSpec.describe Api::Users::Bookmarks::CommentsController do
  describe ".index", context: :as_signed_in_user do
    it "returns comments objects" do
      create_list(:comment, 2, created_by: user)

      get "/api/users/#{user.to_param}/bookmarks/comments.json"

      expect(response).to have_http_status(200)
      expect(response).to match_json_schema("controllers/api/users/bookmarks/comments_controller/index/200")
    end
  end
end