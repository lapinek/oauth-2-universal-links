# Testing OAuth 2.0 Redirection with Universal Links

This is a quick demonstration of using Universal Links for OAuth 2.0 redirection. It is NOT suited for any kind of practical application and does not go beyond visiting the authorization endpoint.

Two examples are provided and commented on in the code, and you should be able to try your own Identity Provider and Universal Links setup.

You will need:

0. Join [Apple Developer Program](https://developer.apple.com/programs/)

    You will need to associate you project with a development team account and provide the team ID in your Apple App Site Association file, as a part of your app identifier.

0. [Enable Universal Links](https://developer.apple.com/documentation/uikit/core_app/allowing_apps_and_websites_to_link_to_your_content/enabling_universal_links)

    You will need to add your Universal Links associated domain to the app.

0. Create an OAuth 2.0 client

    For example, [Google](https://developers.google.com/identity/protocols/OAuth2) can serve as a provider. For testing Universal Links with Google, you will need an `OAuth client ID` of the `Web application` type. Choosing the `iOS` option will let you use a custom scheme only.

0. Provide your provider and client details, for example:

    ```swift
    // ViewController.swift

    // . . .

    authorizationEndpoint = "https://accounts.google.com/o/oauth2/v2/auth"
    clientId = "your-client.apps.googleusercontent.com"
    redirectUri = "https://your-associated-domain/your-redirection-path"

    // . . .
    ```
