class Api::ProjectsController < ApplicationController
  def index
    @project = Project.all
  end

  def checkout
    @project = Project.where(status_code: :queued).first

    if @project.nil?
      Project.all.update!(status_code: :queued)
      Asset.destroy_all
      head 418
    else
      @project.assigned!
    end
  end

  def assets
    @project = Project.find(params[:project_id])

    Asset.create(project: @project, file: params[:file])
  end

  def generated
    @project = Project.find(params[:project_id])
    @project.generated!
  end
end
