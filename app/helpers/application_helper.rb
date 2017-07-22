module ApplicationHelper
  def link_to_add_fields(name, f, type)
    new_object = f.object.send "build_#{type}"
    id = "new_#{type}"
    fields = f.send("#{type}_fields", new_object, child_index: id) do |builder|
      render('shared/' + type.to_s + '_fields', f: builder)
    end
    link_to(name, '#', class: 'add_fields', data: { id: id, fields: fields.delete("\n") })
  end

  def xeditable?(arg)
    true
  end

  def page_title(title)
    content_for :page_title do
      title
    end
  end

  def source_action_icons(source, actions = [])
    out = ''

    out += (link_to edit_polymorphic_path(source), class: 'btn btn-sm btn-default btn-xs' do
      content_tag(:i, '', class: 'fa fa-pencil')
    end) if actions.include?('edit')

    out += (link_to source, class: 'btn btn-sm btn-default btn-xs' do
      content_tag(:i, '', class: 'fa fa-eye')
    end) if actions.include?('show')

    out += (link_to source, :method => :delete, :data => { :confirm => 'Are you sure?' }, remote: actions.include?('remote'), class: 'btn btn-sm btn-danger btn-xs' do
      content_tag(:i, '', class: 'fa fa-trash')
    end) if actions.include?('destroy')

    out
  end
end
