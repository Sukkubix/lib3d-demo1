# Requires: gem 'multipart-post'

require "byebug"
require "uri"
require "net/http"
require "json"
require "fileutils"
require "open-uri"
require 'net/http/post/multipart'

API_KEY = "YOUR-API-KEY-HERE"

loop do
  uri = URI("http://localhost:3000/api/projects/checkout")
  res = Net::HTTP.post_form(uri, api_key: API_KEY)

  if res.code == "418"
    puts "We are a teapot, and don't yet have a file to process"
    puts "Sleep for a few minutes before trying again"
    sleep 10
  elsif res.code == "200"
    puts "Project retrieved"

    json = JSON.parse(res.body, symbolize_names: true)

    folder = File.join(__dir__, "project_output", SecureRandom.hex)

    puts "Tempfolder: #{folder}"

    FileUtils.mkdir_p(folder)

    puts "Downloading images"
    json[:images].each do |image|
      Net::HTTP.start("localhost", 3000) { |http|
        resp = http.get("/smiley.jpg")
        open(File.join(folder, "#{image[:id]}.#{image[:default_format]}"), "wb") { |file|
          file.write(resp.body)
        }
      }
    end

    puts "Generating assets"
    # 
    # 
    # PHOTOGAMMETRY CODE GOES HERE
    # 
    # 

    # TODO: Add whatever system call code you need here
    system("echo 'We are generating a bunch of stuff'")
    # For demo, lets download benchy
    Net::HTTP.start("localhost", 3000) { |http|
      resp = http.get("/3DBenchy.stl")
      open(File.join(folder, "benchy.stl"), "wb") { |file|
        file.write(resp.body)
      }
    }

    # 
    # 
    # END OF PHOTOGAMMETRY CODE
    # 
    # 

    puts "Generation complete"

    url = URI(json[:asset_url])
    File.open(File.join(folder, "benchy.stl")) do |asset|
      req = Net::HTTP::Post::Multipart.new url.path,
        file: UploadIO.new(asset, "application/sla", "benchy.stl"),
        api_key: API_KEY

      Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end
    end

    puts "File upload completed"

    puts "Mark the project as generated"
  
    Net::HTTP.post_form(URI(json[:generated_url]), api_key: API_KEY)
  else
    puts "Error received from server, will try again later. STATUS_CODE: #{res.code}"
  end
end
