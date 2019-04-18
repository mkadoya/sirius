ActiveAdmin.register Option do
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

permit_params { Option.attribute_names.map(&:to_sym) }

index do
    selectable_column
    id_column
    column :option_id
    column :question_id
    column :category
    column :content
    column :next_question_id
    column :created_at
    column :updated_at
    actions
end

form do |f|
    inputs 'Form' do
        input :option_id
        input :question_id
        input :category
        input :content
        input :next_question_id
    end
    actions
end

csv do
    column :option_id
    column :question_id
    column :category
    column :content
    column :next_question_id
end

end
