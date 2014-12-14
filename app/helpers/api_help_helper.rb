module ApiHelpHelper
  def index_row_entry(sr_no, name, link_href, method_type)
    content_tag :tr do 
      content_tag(:td, sr_no) + 
      content_tag(:td, link_to(name, link_href)) +
      content_tag(:td, method_type) 
    end
  end
end
