json.timestamp DateTime.now
json.page 1
json.page_count 1

json.projects @projects do |project|
  json.id project.id
  json.percent 0
  json.state project.status_code
  json.assigned_node nil
  json.created_at project.created_at
  json.updated_at project.updated_at
end
