ActiveAdmin.register Article do
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
permit_params { Article.attribute_names.map(&:to_sym) }

form do |f|
    inputs 'Form' do
        input :title
        input :preview
        input :content, as: :froala_editor, :input_html => { :height => '500px' }
        input :image
    end
    actions
end
end
