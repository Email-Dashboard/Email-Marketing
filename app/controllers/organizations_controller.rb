class OrganizationsController < ApplicationController
  def index
    @organizations = current_user.organizations
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)

    @organization.acls = [Acl.new(role: Role.find_by(identifier: 'owner'), user: current_user)]

    if @organization.save
      redirect_to contacts_url(subdomain: @organization.subdomain)
    else
      render :new
    end
  end

  def organization_params
    params.require(:organization).permit(:name, :subdomain)
  end
end