class ContactsController < ApplicationController
  def index
    @contacts = Contact.all
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      redirect_to contacts_path
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name)
  end
end