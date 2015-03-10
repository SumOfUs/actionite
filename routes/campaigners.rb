class Campaigners < Cuba
  # We set the 'campaigners' layout as master template (file: /views/layout.campaigners.mote)
  settings[:mote][:layout] = "layout.campaigners"

  define do
    on "dashboard" do
      render("campaigner/dashboard", title: "Actionite | Dashboard")
    end

    on "actionite" do
      res.redirect("dashboard")
    end

    on root do
      run Guests
    end

    on "logout" do
      logout(Campaigner)
      res.redirect "/"
    end

    on(default) { not_found! }
  end
end
