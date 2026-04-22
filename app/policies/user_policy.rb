class UserPolicy < ApplicationPolicy
  # Sysadmin vê todos; outros só veem usuários não-protegidos
  def index?
    true
  end

  def show?
    true
  end

  def create?
    return true if sysadmin?
    allowed?("users", "create")
  end

  def update?
    return true if sysadmin?
    return false if record.admin_protected?  # Partner não edita sysadmin/super_admin

    allowed?("users", "update")
  end

  def destroy?
    return false if record == user             # ninguém exclui a si mesmo
    return true  if sysadmin?
    return false if record.admin_protected?   # Partner não exclui sysadmin/super_admin

    allowed?("users", "destroy")
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.sysadmin?

      # Partner e demais veem apenas usuários não-protegidos
      protected_group_ids = Group.where(code: Group::PROTECTED_CODES).pluck(:id)
      admin_user_ids = UserAssignment.where(group_id: protected_group_ids).pluck(:user_id)

      scope.where.not(id: admin_user_ids)
    end
  end
end
