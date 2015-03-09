class Guests < Cuba
  settings[:mote][:layout] = "layout.guests"

  define do
    # Homepage for campaigners (when going to http://192.168.59.103:5000/actionite)
    on "actionite" do
      render("actionite", title: "Actionite | Login")
    end

    # Here is where the Google API first response arrives and we send it
    # to "login/:access_token"
    on "google_oauth" do
      on param("access_token") do |access_token|
        res.redirect "/login/#{ access_token }"
      end
    end

    # Once a campaigner clicks on SignIn google button, we send the request to
    # Google and receive several values from the Google API. Then we use the
    # 'token_access' value to send a GET request to Google again to get some
    # user's details, google id and email among others. We use those values to
    # create a new campaigner in the db (without any password), then we
    # authenticate that campaigner and then it redirects to '/dashboard'
    # on Campaigners route which will be the homepage for the campaigns.
    on "login/:access_token" do |access_token|
      google_user = Google.fetch_user(access_token)

      # Example: {"kind"=>"plus#person", "etag"=>"\"RqKWnRU4WW46-6W3rWhLR9iFZQM/kcT6GjinXWesHqvTtumowMTYI8k\"", "gender"=>"female", "emails"=>[{"value"=>"cecilia@sumofus.org", "type"=>"account"}], "objectType"=>"person", "id"=>"100501244795726503142", "displayName"=>"Cecilia Rivero", "name"=>{"familyName"=>"Rivero", "givenName"=>"Cecilia"}, "url"=>"https://plus.google.com/100501244795726503142", "image"=>{"url"=>"https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg?sz=50", "isDefault"=>true}, "isPlusUser"=>true, "circledByCount"=>0, "verified"=>false, "domain"=>"sumofus.org"}

      on google_user do
        # Checks the correct domain
        # Correct domain
        if google_user['domain'] == "sumofus.org"
          # Tries to find the campaigner in the db
          campaigner = Campaigner.fetch(google_user['id'])

          # if campaigner is not found, creates a new campaigner in the db
          if campaigner.nil?
            google_id = google_user['id']
            email = google_user['emails'][0]['value']

            campaigner = Campaigner.create(google_id: google_id, email: email)
          end

          # Authenticates the campaigner, from this moment, inside the session
          # there's going to be a key like: "Campaigner"=>1
          authenticate(campaigner)

          # It redirects to /dashboard in the Campaigners route (routes folder)
          res.redirect "/dashboard"
        # Wrong domain, goes back to members homepage
        else
          res.redirect "/"
        end
      end

      # The response from google was incorrect for some reason
      on google_user.nil? do
        res.redirect "/actionite"
      end
    end

    # Homepage for members (when going to http://192.168.59.103:5000)
    on root do
      render("home", title: "SumOfUs")
    end

    # Here we use the not_found! method provided from UsersHelpers (inside 'helpers' folder)
    on(default) { not_found! }
  end
end
