module ApplicationHelper
  include ActionView::Helpers::DateHelper
  def authorize_user!
    if params[:id].present? && current_user.id != params[:id]
      raise Exceptions::UnauthorizedException
    end
  end

  # def paginate(scope, name = nil, default_per_page = 10, url = nil, alter = nil)
  #   current, total, per_page = 0,1,0
  #   collection = []
  #   if alter.nil?
  #     collection = scope.page(params[:page]).per((params[:per_page] || default_per_page).to_i)

  #     current, total, per_page = collection.current_page, collection.total_pages, collection.limit_value

  #     collection_name = name || collection.model.name.downcase.pluralize
  #   else

  #     page = params[:page].to_i || 0
  #     off_set = ( page ) * 10 
  #     per_pick = params[:per_page].present? ? params[:per_page].to_i : 10

  #     collection = alter.drop(off_set).first((per_pick))

  #     current = params[:page].present? ? params[:page].to_i : 1
  #     total =  (alter.size.to_f / per_pick).ceil if (alter.size >= 10)
  #     per_page = per_pick.to_i
  #   end

  #   pagination = {
  #     pagination: {
  #       current:  current,
  #       previous: url.nil? ? (current > 1 ? "#{request.path}?page=#{(current - 1)}" : nil) : (current > 1 ? url.call+"&page=#{(current - 1)}" : nil),
  #       next: url.nil? ? (current >= total ? nil : "#{request.path}?page=#{(current + 1)}") : (current >= total ? nil : url.call+"&page=#{(current + 1)}"),
  #       per_page: per_page,
  #       pages:    total,
  #       count:    scope.present? ? collection.total_count : alter.size
  #     },
  #     status: 200
  #   }

  #   return collection, pagination

  # end
end
