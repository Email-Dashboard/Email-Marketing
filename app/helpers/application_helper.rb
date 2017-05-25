module ApplicationHelper
  def link_to_add_fields(name, f, type)
    new_object = f.object.send "build_#{type}"
    id = "new_#{type}"
    fields = f.send("#{type}_fields", new_object, child_index: id) do |builder|
      render('shared/' + type.to_s + '_fields', f: builder)
    end
    link_to(name, '#', class: 'add_fields', data: { id: id, fields: fields.delete("\n") })
  end

  def find_imap_user(email)
    current_account.users.find_by(email: email)
  end
end
