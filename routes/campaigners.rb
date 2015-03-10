class Campaigners < Cuba
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

    on "petitions/new" do
      render "petition/new", title: "Actionite | Create New Petition", petition: Petition.new, form: partial('petition/form')
    end

    on "petitions/edit/:slug" do |slug|
      petition = Petition.find_by_slug slug
      render "petition/edit", title: "Actionite | Create New Petition", petition: petition
    end

    on "petitions" do
      render "petition/index", title: "Actionite | Petitions"
    end

    on(default) { not_found! }
  end
end
