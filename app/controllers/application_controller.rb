class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_current_user

  def api_request?
    request.format.symbol == :json
  end

  def date_formatter date
    date = date
    min = date.match(/((:)[0-9])\d+/)
    date.gsub!(/((:)[0-9])\d+/, "#{min}:00").downcase!
    DateTime.strptime(date, '%m/%d/%Y %I:%M:%S %p')
  end

  def set_current_user
    if api_request?
      if request.headers['Authorization'] && request.headers['Authorization'].match(/Bearer (.+)/)
        token = request.headers['Authorization'].match(/Bearer (.+)/)[1]
      end
      token ||= params[:access_token]
      @current_user ||= User.active.joins("LEFT JOIN api_keys AS a on a.user_id = users.id").where("a.key = ? AND a.expires_at > ?", SecurityHelper.sha_hash(token), Time.now).first if token
    end
    @current_user ||= User.active.find_by(id: session[:current_user_id])
  end

  def current_user
    @current_user
  end

  def current_entity
    @current_entity = current_user.entity if logged_in?
  end

  def logged_in?
    !!current_user
  end

  def js_env(opts = {})
    @js_env ||= { current_user: current_user.try(:id), current_entity: current_entity.try(:id) }
    @js_env.merge!(opts) unless opts.empty?
    @js_env
  end

  private :set_current_user
  helper_method :js_env
  helper_method :current_user
  helper_method :logged_in?
  helper_method :current_entity
end
