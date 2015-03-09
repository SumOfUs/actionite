class Campaigners < Cuba
  define do
    on "dashboard" do
      render("campaigner/dashboard", title: "Actionite | Dashboard")
    end

    on "actionite" do
      res.redirect("dashboard")
    end

    on root do
      render("home", title: "SumOfUs")
    end

    on "logout" do
      logout(Campaigner)
      res.redirect "/"
    end

    on(default) { not_found! }
  end
end
