class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user

    @user   = user
    @record = record
  end

  # Sysadmin tem acesso irrestrito a tudo
  def sysadmin?
    user.sysadmin?
  end

  # Verifica se algum grupo do usuário tem a rule habilitada para resource+action
  def allowed?(resource, action)
    return true if sysadmin?

    group_ids = user.groups.pluck(:id)
    Rule.allowed?(group_ids, resource, action)
  end

  def index?
    allowed?(resource_name, "read")
  end

  def show?
    allowed?(resource_name, "read")
  end

  def new?
    allowed?(resource_name, "create")
  end

  def create?
    allowed?(resource_name, "create")
  end

  def edit?
    allowed?(resource_name, "update")
  end

  def update?
    allowed?(resource_name, "update")
  end

  def destroy?
    allowed?(resource_name, "destroy")
  end

  private

  # Infere o nome do resource a partir da policy. Ex: ProductPolicy → "products"
  def resource_name
    self.class.name.sub("Policy", "").underscore.pluralize
  end

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      @scope.all
    end

    private

    attr_reader :user, :scope
  end
end
