# frozen_string_literal: true

class ContributorsController < ApplicationController
  before_action :set_contributor, only: [:destroy]
  before_action :set_sub
  before_action :set_facade
  before_action -> { authorize(Contributor) }, only: [:index, :new, :create]
  before_action -> { authorize(@contributor) }, only: [:destroy]

  def index
    @records, @pagination = scope.paginate(after: params[:after])
  end

  def new
    @form = CreateContributorForm.new

    render partial: "new"
  end

  def create
    @form = CreateContributorForm.new(create_params)

    if @form.save
      head :no_content, location: contributors_path(sub: @sub)
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  def destroy
    DeleteContributorService.new(@contributor).call

    head :no_content
  end

  private

  def context
    Context.new(current_user, @sub)
  end

  def scope
    query_class = ContributorsQuery

    if @sub.present?
      scope = query_class.new.sub(@sub)
    else
      scope = query_class.new.global
    end

    scope = query_class.new(scope).filter_by_username(params[:query])
    scope.includes(:user, :approved_by)
  end

  def set_facade
    @facade = ContributorsFacade.new(context)
  end

  def set_sub
    if @contributor.present?
      @sub = @contributor.sub
    elsif params[:sub].present?
      @sub = SubsQuery.new.where_url(params[:sub]).take!
    end
  end

  def set_contributor
    @contributor = Contributor.find(params[:id])
  end

  def create_params
    attributes = policy(Contributor).permitted_attributes_for_create

    params.require(:create_contributor_form).permit(attributes).merge(sub: @sub, approved_by: current_user)
  end
end
