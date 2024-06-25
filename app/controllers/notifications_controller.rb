# app/controllers/notifications_controller.rb

class NotificationsController < ApplicationController
  # GET /notifications
  def index
    user = User.find params[:id]  # Assuming current_user method is defined for authentication
    company = user.company  # Assuming user belongs to a company

    # Fetch notifications for admin users of the company
    admin_notifications = Notification.where(receiver_type: 'admin', receiver_id: company.users.where(role: 'admin').pluck(:id), company_id: company.id)
                                      .order(created_at: :desc).limit(10)

    # Fetch notifications for HR users of the company
    hr_notifications = Notification.where(receiver_type: 'HR', receiver_id: company.users.where(role: 'HR').pluck(:id), company_id: company.id)
                                    .order(created_at: :desc).limit(10)

    # Combine admin and HR notifications
    notifications = admin_notifications + hr_notifications

    render json: notifications
  end
end
