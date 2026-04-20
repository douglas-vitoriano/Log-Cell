Trestle.resource(:account, model: User, scope: Auth, singular: true) do
  instance do
    current_user
  end

  remove_action :new, :edit, :destroy

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
    if instance.encrypted_password_previously_changed?
      login!(instance)
    end
  end if Devise.sign_in_after_reset_password

  params do |params|
    params.require(:account).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
