class Campaigners < Cuba
  # We set the 'campaigners' layout as master template (file: /views/layout.campaigners.mote)
  settings[:mote][:layout] = "layout.campaigners"

  define do
    on "dashboard" do
      petitions = Petition.order(:created_at).limit(3)
      donations = Donation.order(:created_at).limit(3)
      render("campaigner/dashboard", title: "Dashboard",
        petitions: petitions, donations: donations,
        campaigner: current_user)
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

    ###################################
    ## Petitions
    ###################################
    on "petitions/new" do
      render("petition/new",
             title: "Create New Petition",
             form: partial('petition/form', petition: Petition.new, page_type: 'Petition', target: 'petitions'))
    end

    on "petitions/view/:slug" do |slug|
      petition = Petition.find_by_slug slug
      render("petition/view", title: "View Petition", petition: petition)
    end

    on "petitions/save" do
      on post do
        params = req.POST

        image = Cropped_image.new(params)
        image.crop
        image.resize
        image.cleanup

        # Delete imagemagick reference - this needs to be done to prevent memory leakage
        image = nil
        $LOG.debug("image: #{image}")

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
        if petition.required_fields
          petition.reset_required_fields
        end
        petition.add_required_fields params['required_fields'].keys
        petition.blockquote = params['blockquote']
        save_time = Time.now
        petition.updated_at = save_time

        if not petition.created_at
          petition.created_at = save_time
        end

        petition.save

        # TODO: This isn't saving the language for reasons unknown, need to fix.
        res.write(AK_CONNECTOR.create_petition_page(
            name=petition.slug,
            title=petition.title,
            lang=petition.language,
            canonical_url="#{env['HTTP_ORIGIN']}/petition/#{params['slug']}"
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
             title: "Create New Petition",
             form: partial('petition/form', petition: petition, page_type: 'Petition', target: 'petitions'))
    end

    on "petitions" do
      render "petition/index", title: "Petitions"
    end

    ###################################
    ## Donations
    ###################################

    on "donations/new" do
      donation = Donation.new
      render("donation/new",
             title: "Create New Donation Page",
             form: partial('petition/form', petition: donation, page_type: 'Donation Page', target: 'donations',
                           donation_form: partial('donation/donation_subform', donation: donation)))
    end

    on "donations/view/:slug" do |slug|
      donation = Donation.find_by_slug slug
      render("donation/view", title: "View Petition", donation: donation)
    end

    on "donations/edit/:slug" do |slug|
      donation = Donation.find_by_slug slug
      render("donation/new",
             title: "Create New Donation Page",
             form: partial('petition/form', petition: donation, page_type: 'Donation Page', target: 'donations',
                           donation_form: partial('donation/donation_subform', donation: donation)))
    end

    on "donations/save" do
      on post do
        params = req.POST
        donation = (Donation.find_by_slug params['slug'] or Donation.new)
        donation.name = params['name']
        donation.title = params['title']
        donation.slug = params['slug']
        donation.body = params['body']
        donation.mobile_body = params['mobile_body']
        donation.facebook_title = params['facebook_title']
        donation.language = params['language']
        donation.alt_body = params['alt_body']
        donation.image_url = params['image_url']
        donation.image_text = params['image_text']
        donation.suggested_tweets = params['suggested_tweets']
        donation.goal = params['goal']
        donation.auto_increment_goal = params['auto_increment_goal']
        if donation.required_fields
          donation.reset_required_fields
        end
        donation.add_required_fields params['required_fields'].keys

        if donation.donation_amounts
          donation.reset_donation_amounts
        end
        donation.add_donation_amounts params['donation_amounts'].keys
        donation.blockquote = params['blockquote']
        save_time = Time.now
        donation.updated_at = save_time

        if not donation.created_at
          donation.created_at = save_time
        end

        donation.save

        # TODO: This isn't saving the language for reasons unknown, need to fix.
        res.write(AK_CONNECTOR.create_donation_page(
                      name=donation.slug,
                      title=donation.title,
                      lang=donation.language,
                      canonical_url="#{env['HTTP_ORIGIN']}/donation/#{params['slug']}"
                  ))
        res.redirect "/donations/edit/#{params['slug']}"
      end
    end

    on "donations/disable/:slug" do |slug|
      donation = Donation.find_by_slug slug
      if donation
        donation.disabled = !donation.disabled
        donation.save
      else
        not_found!
      end

      res.redirect "/donations/edit/#{slug}"
    end


    on(default) { not_found! }
  end
end
