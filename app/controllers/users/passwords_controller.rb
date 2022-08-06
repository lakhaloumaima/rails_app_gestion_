
class Users::PasswordsController < Devise::PasswordsController
    def after_resetting_password_path_for(resource)
      #super(resource)
      root_path
    end



    def update
        self.resource = resource_class.reset_password_by_token(resource_params)
      
        if resource.errors.empty?
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          set_flash_message(:notice, "Your flash message here")
          redirect_to new_user_session_path
        else
          respond_with resource
        end
    end
    
end
