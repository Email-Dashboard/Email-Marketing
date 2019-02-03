class Organization < ApplicationRecord
  after_create :create_tenant

  has_many :acls

  has_many :users, through: :acls

  validates_presence_of :name, :subdomain

  validates_uniqueness_of :subdomain

  def create_tenant
    Apartment::Tenant.create(subdomain)
  end
end
