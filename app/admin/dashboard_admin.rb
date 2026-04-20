Trestle.admin(:dashboard) do
  menu do
    item :dashboard, icon: "fas fa-chart-bar",
                     label: "Dashboard",
                     priority: :first
  end

  controller do
    def index
    end
  end
end
