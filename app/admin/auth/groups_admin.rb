Trestle.resource(:groups, model: Group, scope: Auth) do
  menu do
    item :groups, icon: "fas fa-layer-group",
                  label: I18n.t("sidebar.group", default: "Grupos"),
                  group: I18n.t("delimiter.config", default: "Configurações"),
                  priority: 8
  end

  collection do
    if current_user.sysadmin?
      Group.all
    else
      Group.assignable_by_partner
    end
  end

  table do
    column :name,    header: "Nome"
    column :code,    header: "Código"
    column :enabled, header: "Ativo"
    column :rules_count, header: "Regras" do |group|
      group.rules.enabled.count
    end
    actions do |toolbar, instance|
      toolbar.edit   if current_user.sysadmin? || (!instance.protected? && current_user.partner?)
      toolbar.delete if current_user.sysadmin? && !instance.protected?
    end
  end

  form do |group|
    row do
      col(sm: 6) { text_field :name,    label: "Nome" }
      col(sm: 3) { text_field :code,    label: "Código", disabled: !current_user.sysadmin? }
      col(sm: 3) { check_box  :enabled, label: "Ativo" }
    end

    tag.hr

    tag.h5("Permissões", class: "mb-3")

    Rule::RESOURCES.each do |resource|
      row(class: "align-items-center mb-2") do
        col(sm: 2) do
          tag.strong(I18n.t("rules.resources.#{resource}", default: resource.humanize))
        end

        Rule::ACTIONS.each do |action|
          col(sm: 2, class: "d-flex align-items-center gap-1") do
            existing_rule = group.rules.find_or_initialize_by(resource: resource, action: action)

            check_box_tag(
              "group[rules_attributes][#{resource}_#{action}][enabled]",
              "1",
              existing_rule.enabled?,
              id: "rule_#{resource}_#{action}"
            ) + label_tag(
              "rule_#{resource}_#{action}",
              I18n.t("rules.actions.#{action}", default: action.capitalize),
              class: "mb-0 ml-1"
            )
          end
        end
      end
    end
  end

  update_instance do |instance, attrs|
    rules_attrs = attrs.delete(:rules_attributes)
    instance.assign_attributes(attrs)

    if rules_attrs && current_user.sysadmin?
      Rule::RESOURCES.each do |resource|
        Rule::ACTIONS.each do |action|
          key     = "#{resource}_#{action}"
          enabled = rules_attrs.dig(key, :enabled) == "1"
          rule    = instance.rules.find_or_initialize_by(resource: resource, action: action)
          rule.enabled = enabled
          rule.save! if rule.changed? || rule.new_record?
        end
      end
    end
  end

  params do |params|
    base = params.require(:group).permit(:name, :code, :enabled)

    if params[:group][:rules_attributes].present?
      rules_permitted = {}
      Rule::RESOURCES.each do |resource|
        Rule::ACTIONS.each do |action|
          rules_permitted["#{resource}_#{action}"] = [ :enabled ]
        end
      end
      base.merge!(rules_attributes: params[:group][:rules_attributes].permit(rules_permitted))
    end

    base
  end
end
