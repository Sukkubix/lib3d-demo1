json.timestamp DateTime.now

json.id @project.id
json.state @project.status_code
json.created_at @project.created_at
json.updated_at @project.updated_at

json.images @project.images do |image|
  json.id image.id
  json.url "http://localhost:3000/smiley.jpg"
  json.formats [:jpg]
  json.default_format :jpg
  json.original_format :jpg
end

json.asset_url api_project_assets_url(@project)
json.generated_url api_project_generated_url(@project)
