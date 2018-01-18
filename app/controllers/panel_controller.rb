 class PanelController < ApplicationController
  
  URL = 'https://app.pipefy.com/queries'
  HEADER = { :content_type => 'application/json',
             :authorization => 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ1c2VyIjp7ImlkIjo2NjE0MCwiZW1haWwiOiJwaXBlZnlkZXZyZWNydWl0aW5nZmFrZXVzZXJAbWFpbGluYXRvci5jb20iLCJhcHBsaWNhdGlvbiI6NDUzOH19.uUX4KIR4m_K-8NwLYhtVpsNnLEoLARebIQiyQDxEm3RZLHCffLrcH-V8RmuJLu8nqE8AQ-SvqUvgz3fe0UyZ4w' }
  
  def index
    @organization = Organization.org_test
    @pipe = Pipe.pipe_test
  end

  def fetch_data
    response = RestClient.post URL, graph_query, HEADER
    if valid?(response)
      data = JSON.parse(response.body)['data']&.dig('organization')
      Organization.handle_api_data(data)
      redirect_back fallback_location: root_path
    else
      flash[:warning] = I18n.t('.error', code: response.code)
      redirect_back fallback_location: root_path
    end
  end

  private

  def valid?(response)
    response.code == 200 && !JSON.parse(response.body).has_key?("errors")
  end

  def graph_query
    {"query": "{ organization(id: #{Organization::ID_TEST}) { name pipes { id name phases { id name cards { edges { node { id title created_at due_date fields { name value } labels { id name }}}}}}}}"}
  end

end