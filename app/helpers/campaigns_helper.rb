module CampaignsHelper
  def status_card(display_text, count, status_percent)
    content_tag :div, class: 'col-md-2 col-sm-4 col-xs-6 tile_stats_count' do
      (content_tag :span, class: 'count_top' do
        concat (display_text)
      end) +

      (content_tag :div, class: 'count' do
        count.to_s
      end) +

      (content_tag :span, class: 'count_bottom' do
        content_tag :i, class: 'content'
        "#{status_percent} %"
      end)
    end
  end
end
