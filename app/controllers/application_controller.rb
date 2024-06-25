class ApplicationController < ActionController::Base

    # before_action :set_company
    # set_current_tenant_by_subdomain(:company, :subdomain)


    #before_action :authenticate_user!

    protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

    respond_to :json
################################################################################

    private

    # def set_company
    #     @company = Company.find_by(subdomain: request.subdomain)
    #     if @company.nil? && !request.subdomain.empty?
    #         redirect_to root_url(subdomain: nil), alert: 'Company not found'
    #     end
    # end

end
