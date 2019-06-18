//
//  ViewController.swift
//  oauth-2-universal-links
//
//  Created by Konstantin Lapine on 5/23/19.
//  Copyright © 2019 Forgerock. All rights reserved.
//

import UIKit
import AuthenticationServices
import SafariServices

@available(iOS 12.0, *)
var aSWebAuthenticationSession: ASWebAuthenticationSession? = nil

@available(iOS 11.0, *)
var sFAuthenticationSession: SFAuthenticationSession? = nil

class ViewController: UIViewController {
    var url: URL!
    var authorizationEndpoint: String!
    var clientId: String!
    var redirectUri: String!
    var scope: String!
    var prompt: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Example Identity Providers

        // setGoogleExample()

        setForgeRockExample()

        var urlString = ""
        urlString += authorizationEndpoint + "?response_type=code"
        urlString += "&redirect_uri=" + redirectUri
        urlString += "&client_id=" + clientId
        urlString += "&scope=" + scope
        if let prompt = prompt {
            urlString += "&prompt=" + prompt
        }
        urlString += "&nonce=nonce&state=state&code_challenge_method=S256&code_challenge=SxRdd4fbJ1_XMqpbgASNspQzJlJ_oVnKDEY4PnlRFUM"

        url = URL(string: urlString)

        showUi()
    }

    func setGoogleExample() {
        // Provide the authorization endpoint URL and your OAuth 2.0 client specifics
        // You will need to register your client as a web application to allow for https:// redirection
        authorizationEndpoint = "https://accounts.google.com/o/oauth2/v2/auth"
        clientId = "your-client.apps.googleusercontent.com"
        redirectUri = "https://your-associated-domain/your-redirection-path"

        /*
         OAuth 2.0 scopes.

         No "sensitive" scope is initially included; hence, and no intermediate screen is involved (unless the user needs to authenticate). This will not redirect the Universal Link to the app when in-app browser tabs are used. With Safari, if the user has to sign in or choose an account, the redirection from the intermediate screen to the authorization endpoint and consequent redirection to the Universal Link will open the app.
         */
        scope = "openid%20profile"

        // Prompting for user consent will bring an intermediate screen that will redirect to the authorization endpoint;
        // UNCOMMENT next line in order for the Universal Link to be redirected to the app in Safari (but NOT in the in-app browser tabs
        // prompt = "consent"

        // Adding a sensitive scope, `https://mail.google.com/`, induces a consent screen from which the user can initiate the authorization request. This allows the in-app browser tabs to redirect the Universal Link to the app.
        // UNCOMMENT next line in order for the Universal Link to be redirected to the app in  the in-app browser tabs.
        // scope += "%20https://mail.google.com/"
    }

    func setForgeRockExample() {
        // Provide the authorization endpoint URL and your OAuth 2.0 client specifics

        authorizationEndpoint = "https://login.sample.forgeops.com/oauth2/authorize"
        clientId = "ios-appauth-basic"
        redirectUri = "https://lapinek.github.io/oauth2redirect/oauth-2-universal-links"

        // OAuth 2.0 scopes.
        scope = "openid%20profile"

        // Show a consent screen from which the user can initiate authorization request, when the user's consent is not implied but has been saved;
        // UNCOMMENT next line in order for the Universal Link to be redirected to the app in the in-app browser tabs:
        // prompt = "consent"
    }

    @objc func startAuthenticationSession() {
        if #available(iOS 12.0, *) {
            aSWebAuthenticationSession = ASWebAuthenticationSession.init(url: url!, callbackURLScheme: "https") {
                url, error in

                if let error = error {
                    print("ERROR: ", error.localizedDescription)
                }
            }

            aSWebAuthenticationSession!.start()
        } else if #available(iOS 11.0, *) {
            sFAuthenticationSession = SFAuthenticationSession.init(url: url!, callbackURLScheme: nil) {
                url, error in

                if let error = error {
                    print("ERROR: ", error.localizedDescription)
                }
            }

            sFAuthenticationSession!.start()
        }
    }

    @objc func startSafariViewController() {
        let sFSafariViewController = SFSafariViewController(url: url!)

        self.present(sFSafariViewController, animated: true, completion: nil)
    }

    @objc func startSafari() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }

    func showUi() {
        let aButton = UIBarButtonItem(title: "ASession", style: .plain, target: self, action: #selector(startAuthenticationSession))
        let svButton = UIBarButtonItem(title: "SafariVC", style: .plain, target: self, action: #selector(startSafariViewController))
        let sButton = UIBarButtonItem(title: "Safari", style: .plain, target: self, action: #selector(startSafari))

        navigationItem.rightBarButtonItems = [aButton, svButton, sButton]
    }
}

