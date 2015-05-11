module ApplicationHelper

  def super_admin_signed_in?
    user_signed_in? && current_user.super_admin?
  end

  def nav_link(text, path, condition=false, options={})
    class_name = (current_page?(path) || condition) ? "active" : ""

    content_tag(:li, class: class_name) do
      options[:title] = text unless options.has_key?(:title)
      link_to text, path, options
    end
  end

  def body_class
    qualified_controller_name = controller.controller_path.gsub("/", "-")
    "#{qualified_controller_name} #{qualified_controller_name}-#{controller.action_name}"
  end

  def keywords(keywords=nil)
    keywords.presence
  end

end
