ActiveAdmin.register Question do
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

permit_params { Question.attribute_names.map(&:to_sym) }

index do
    selectable_column
    id_column
    column :question_id
    column :category
    column :content
    column :remain_question_num
    column :created_at
    column :updated_at
    actions
end

form do |f|
    inputs 'Form' do
        input :question_id
        input :category
        input :content
        input :remain_question_num
    end
    actions
end

csv do
    column :question_id
    column :category
    column :content
    column :remain_question_num
end

end
