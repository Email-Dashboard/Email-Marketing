class CreateUserJob < ApplicationJob
  queue_as :user_create_or_update

  rescue_from do
    retry_job queue: :user_create_or_update
  end

  def perform(account_id, row, tag_ids)
    account_user = User.where(account_id: account_id).find_or_initialize_by(email: row['email'])

    account_user.name = row['name']

    account_user.save!

    account_user.tag_ids = (tag_ids + account_user.tags.map(&:id)).uniq

    # Save key val attributes

    attribute_keys = (row.keys - %w(email name))

    old_attributes = account_user.user_attributes.where('key IN (?)', attribute_keys)

    old_attributes.each do |attr|
      attr.update(value: row[attr.key])
    end

    new_attribute_keys = attribute_keys - old_attributes.map(&:key)

    UserAttribute.bulk_insert do |worker|
      row.select { |k, _v| new_attribute_keys.include?(k) }.each do |k, v|
        worker.add(key: k, value: v, user_id: account_user.id)
      end
    end
  end
end
