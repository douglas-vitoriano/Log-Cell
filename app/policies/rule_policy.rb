class RulePolicy < ApplicationPolicy
  # Todos podem listar/ver regras (para exibição no form de grupos)
  def index?
    true
  end

  def show?
    true
  end

  # Apenas sysadmin pode criar, editar ou excluir regras
  def create?
    sysadmin?
  end

  def update?
    sysadmin?
  end

  def destroy?
    sysadmin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
