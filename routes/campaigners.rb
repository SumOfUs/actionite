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
      res.redirect "/"
    end

    on "logout" do
      logout(Campaigner)
      res.redirect "/"
    end

    on "petitions/new" do
      render("petition/new",
             title: "Actionite | Create New Petition",
             form: partial('petition/form', petition: Petition.new))
    end

    on "petitions/save" do
      p params
    end

    on "petitions/edit/:slug" do |slug|
      petition = Petition.find_by_slug slug
      render("petition/edit",
             title: "Actionite | Create New Petition",
             form: partial('petition/form', petition: petition))
    end

    on "petitions" do
      render "petition/index", title: "Actionite | Petitions"
    end

    on(default) { not_found! }
  end
end
