function signinCallback(authResult) {
  if (authResult['status']['signed_in']) {
    // Go to '/google_auth' sending the access_token as param
    window.location = "/google_oauth?access_token=" + String(authResult['access_token']);
  } else {
    // Update the app to reflect a signed out user
    // Possible error values:
    //   "user_signed_out" - User is signed-out
    //   "access_denied" - User denied access to your app
    //   "immediate_failed" - Could not automatically log in the user
    console.log("Sign-in state: " + authResult['error']);
    // window.location = "/";
  }
}
