Trestle.resource(:users, model: User, scope: Auth) do
  menu do
    item :users, icon: "fas fa-users",
                 label: I18n.t("sidebar.user"),
                 group: I18n.t("delimiter.config"),
                 priority: 9
  end

  table do
    column :avatar, header: false do |user|
      if user.avatar.attached?
        tag.img(
          src: Rails.application.routes.url_helpers.rails_blob_path(user.avatar, only_path: true),
          style: "width:36px; height:36px; border-radius:50%; object-fit:cover; border:2px solid rgba(255,255,255,0.14);"
        )
      else
        avatar_for(user)
      end
    end
    column :name
    column :email, link: true
    actions do |a|
      # Não permite deletar sysadmin nem o próprio usuário logado
      a.delete unless a.instance == current_user || a.instance.sysadmin?
    end
  end

  form modal: true do |user|
    row do
      col(sm: 6) { text_field :name }
      col(sm: 6) { text_field :email }
    end

    row do
      col(sm: 6) { password_field :password }
      col(sm: 6) { password_field :password_confirmation }
    end

    row do
      col(sm: 12) { file_field :avatar, label: "Foto do perfil", accept: "image/*" }
    end
  end

  update_instance do |instance, attrs|
    if attrs[:password].blank?
      attrs.delete(:password)
      attrs.delete(:password_confirmation) if attrs[:password_confirmation].blank?
    end
    instance.assign_attributes(attrs)
  end

  after_action on: :update do
    if instance == current_user && instance.encrypted_password_previously_changed?
      login!(instance)
    end
  end if Devise.sign_in_after_reset_password

  params do |params|
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
