# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  before_filter :require_admin

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
    def require_admin

    end
end
