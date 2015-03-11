require 'actionkit_connector'

class Campaigners < Cuba
  # We set the 'campaigners' layout as master template (file: /views/layout.campaigners.mote)
  settings[:mote][:layout] = "layout.campaigners"

  # Need our ActionKit connection data.
  AK_API_USER = ENV.fetch 'AK_API_USERNAME'
  AK_API_PASSWORD = ENV.fetch 'AK_API_PASSWORD'
  AK_API_HOST = ENV.fetch 'AK_API_URL'

  ak_connector = ActionKitConnector::Connector.new AK_API_USER, AK_API_PASSWORD, AK_API_HOST

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
      on post do
        params = req.POST
        petition = (Petition.find_by_slug params['slug'] or Petition.new)
        petition.name = params['name']
        petition.title = params['title']
        petition.slug = params['slug']
        petition.body = params['body']
        petition.mobile_body = params['mobile_body']
        petition.facebook_title = params['facebook_title']
        petition.language = params['language']
        petition.alt_body = params['alt_body']
        petition.image_url = params['image_url']
        petition.image_text = params['image_text']
        petition.suggested_tweets = params['suggested_tweets']
        petition.goal = params['goal']
        petition.auto_increment_goal = params['auto_increment_goal']
        petition.add_required_fields params['required_fields'].keys
        petition.blockquote = params['blockquote']
        save_time = Time.now
        petition.updated_at = save_time

        if not petition.created_at
          petition.created_at = save_time
        end

        petition.save

        # TODO: This isn't saving the language for reasons unknown, need to fix.
        res.write(ak_connector.create_petition_page(
            name=petition.slug,
            title=petition.title,
            lang=petition.language,
            canonical_url="#{env['HTTP_ORIGIN']}/petition/"
        ))
        res.redirect "edit/#{params['slug']}"
      end
    end

    on "petitions/disable/:slug" do |slug|
      petition = Petition.find_by_slug slug
      if petition
        petition.disabled = !petition.disabled
        petition.save
      else
        not_found!
      end

      res.redirect "/petitions/edit/#{slug}"
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
