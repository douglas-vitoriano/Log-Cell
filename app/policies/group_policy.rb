class GroupPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    sysadmin?
  end

  def update?
    return true if sysadmin?
    return false if record.protected?   # Partner não altera sysadmin/super_admin

    allowed?("groups", "update")
  end

  def destroy?
    return true if sysadmin?
    return false if record.protected?

    allowed?("groups", "destroy")
  end

  # Permite ao partner ver quais rules estão associadas ao grupo
  def show_rules?
    sysadmin? || user.partner?
  end

  # Permite ao partner associar uma rule existente a um grupo (sem criar nova rule)
  def assign_rule?
    sysadmin? || user.partner?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.sysadmin?

      # Partner vê apenas grupos não-protegidos
      scope.where.not(code: Group::PROTECTED_CODES)
    end
  end
end
