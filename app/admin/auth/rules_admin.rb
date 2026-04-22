Trestle.resource(:rules, model: Rule, scope: Auth) do
  menu do
    item :rules, icon: "fas fa-shield-alt",
                 label: I18n.t("sidebar.rule", default: "Regras"),
                 group: I18n.t("delimiter.config", default: "Configurações"),
                 priority: 7
  end

  collection do
    RuleGroup = Struct.new(:id, :group, :resource, :grouped_rules, keyword_init: true) unless defined?(RuleGroup)

    Rule.includes(:group)
        .order("groups.name, resource")
        .group_by { |r| [ r.group_id, r.resource ] }
        .map do |(group_id, resource), rules|
          RuleGroup.new(
            id:            rules.first.id,
            group:         rules.first.group,
            resource:      resource,
            grouped_rules: rules
          )
        end
  end

  table do
    column :group, header: "Grupo" do |rule|
      rule.group&.name
    end

    column :resource, header: "Recurso" do |rule|
      I18n.t("rules.resources.#{rule.resource}", default: rule.resource.humanize)
    end

    column :actions_list, header: "Ações", sort: false do |rule|
      safe_join(
        rule.grouped_rules.map do |r|
          tag.span(
            I18n.t("rules.actions.#{r.action}", default: r.action.capitalize),
            class: "badge badge-#{action_badge_color(r.action)} mr-1"
          )
        end
      )
    end

    column :enabled, header: "Ativo" do |rule|
      all_enabled = rule.grouped_rules.all?(&:enabled)
      tag.span(all_enabled ? "✅" : "❌", class: all_enabled ? "text-success" : "text-danger")
    end
  end

  form modal: true do |rule|
    row do
      col(sm: 6) do
        select :group_id,
          Group.enabled.map { |g| [ g.name, g.id ] },
          { include_blank: "Selecione o grupo" },
          label: "Grupo"
      end
      col(sm: 3) do
        select :resource,
          Rule::RESOURCES.map { |r| [ I18n.t("rules.resources.#{r}", default: r.humanize), r ] },
          { include_blank: "Selecione o recurso" },
          label: "Recurso"
      end
      col(sm: 3) do
        select :action,
          Rule::ACTIONS.map { |a| [ I18n.t("rules.actions.#{a}", default: a.capitalize), a ] },
          { include_blank: "Selecione a ação" },
          label: "Ação"
      end
    end
    row do
      col(sm: 12) { check_box :enabled, label: "Habilitada" }
    end
  end

  params do |params|
    params.require(:rule).permit(:group_id, :resource, :action, :enabled)
  end

  helper do
    def action_badge_color(action)
      {
        "read"    => "info",
        "create"  => "success",
        "update"  => "warning",
        "destroy" => "danger"
      }.fetch(action, "secondary")
    end
  end
end
