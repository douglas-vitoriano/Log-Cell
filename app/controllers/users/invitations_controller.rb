# app/controllers/users/invitations_controller.rb

class Users::InvitationsController < Devise::InvitationsController
  # GET /users/invitation/new
  # Sobrescreve para injetar grupos disponíveis na view
  def new
    super
  end

  # POST /users/invitation
  # Cria e envia o convite
  def create
    # Injeta quem está convidando para o mailer usar
    self.resource = User.invite!(invite_params, current_inviter)

    if resource.errors.empty?
      redirect_to trestle.auth_users_admin_path,
                  notice: "✉️ Convite enviado para #{resource.email}!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PUT /users/invitation
  # Aceita o convite e define a senha
  def update
    super do |resource|
      if resource.errors.empty?
        # Atribui grupos se enviados no form
        if params[:user][:group_ids].present?
          resource.groups = Group.where(id: params[:user][:group_ids].reject(&:blank?))
          resource.save
        end
      end
    end
  end

  # POST /admin/users/:id/reinvite
  def reinvite
    user = User.find(params[:id])
    user.invite!(current_user)
    redirect_to trestle.auth_users_admin_path,
                notice: "Convite reenviado para #{user.email}!"
  rescue ActiveRecord::RecordNotFound
    redirect_to trestle.auth_users_admin_path, alert: "Usuário não encontrado."
  end

  private

  def invite_params
    params.require(:user).permit(:name, :email, group_ids: [])
  end

  def after_invite_path_for(resource)
    trestle.auth_users_admin_path
  end

  def after_accept_path_for(resource)
    trestle.root_path
  end
end
