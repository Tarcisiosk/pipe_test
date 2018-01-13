Rails.application.routes.draw do
	root to: "panel#index"
  post 'panel/fetch_data',  to: 'panel#fetch_data',   as: :fetch_data
end
