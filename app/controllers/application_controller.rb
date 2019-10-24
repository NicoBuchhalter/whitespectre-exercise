class ApplicationController < ActionController::API

	rescue_from ActiveRecord::RecordNotFound, with: :head_not_found

	def pagination_meta paginated_resource
		{
			current_page: paginated_resource.current_page,
			current_page_count: paginated_resource.count, 
			total_count: paginated_resource.total_count, 
			total_pages: paginated_resource.total_pages,
			per_page: paginated_resource.limit_value
		}
	end

	private

	def head_not_found
		head :not_found
	end
end
