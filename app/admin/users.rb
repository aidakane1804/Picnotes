ActiveAdmin.register User, as: 'People' do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

permit_params :password

index do
  column :username
  column :first_name
  column :last_name
  column :email
  actions
end

show do
  attributes_table do
      row :username
      row :first_name
      row :last_name
      row :email
      row :city
  end
  panel "Visits" do
    attributes_table_for user.first_visit do
      row(:landing_page) { |v| link_to(v.landing_page, v.landing_page) if v.landing_page }
      row(:referrer) { |v| link_to(v.referrer, v.referrer) if v.referrer }
      row('Time to Signup') {|v| distance_of_time_in_words(v.user.created_at, v.started_at) }
      row(:location)
      row(:technology)
      row(:utm_source)
      row(:utm_medium)
      row(:utm_term)
      row(:utm_content)
      row(:utm_campaign)
    end
  end
end

controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      if params[:user][:email].blank?
        params[:user].delete("email")
        params[:user].delete("email_confirmation")
      end
      super
    end
  end
end
