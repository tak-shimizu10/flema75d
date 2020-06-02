
crumb :root do
  link "ホーム", root_path
end

crumb :mypage do
  link "マイページ", user_path
  parent :root
end

crumb :all_items do
  link "商品一覧", all_items_path
  parent :root
end

crumb :all_category do
  link "カテゴリー 一覧",  category_all_items_path
  parent :all_items
end

crumb :parent_category do |category|
  link category.name,  category_all_items_path(category_id:category.id)
  parent :all_category
end

crumb :child_category do |category|
  link category.name,  category_all_items_path(category_id:category.id)
  parent :parent_category, category.parent
end

crumb :grandchild_category do |category|
  link category.name,  category_all_items_path(category_id:category.id)
  parent :child_category, category.parent
end

crumb :show_child_item do |item|
  link item.name, item_path(item.id)
  parent :child_category, item.category
end

crumb :show_grandchild_item do |item|
  link item.name, item_path(item.id)
  parent :grandchild_category, item.category
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).