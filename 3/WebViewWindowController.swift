import Cocoa
import WebKit

class WebViewWindowController: NSWindowController, WKScriptMessageHandler, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!

    override func windowDidLoad() {
        super.windowDidLoad()
        
        //Turn on isInspectable
        webView.isInspectable = true
        
        //Load your bundle (saved app)
        if let url = Bundle.main.url(forResource: "login-page", withExtension: "html", subdirectory: "login-page") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }

        
        // #Example to Load HTML String
        // let htmlString = "<html><body><h1>Hello World!</h1></body></html>"
        // webView.loadHTMLString(htmlString, baseURL: nil)
        

        // #Register callbacks this way
        let contentController = webView.configuration.userContentController
        contentController.add(self, name: "buttonClicked")
        
        // #Inject your own custom script
        let scriptSource = """
        (function() {
            document.getElementById('login-form').addEventListener('submit', function(event) {
                event.preventDefault();
                var username = document.getElementById('username-field').value;
                var password = document.getElementById('password-field').value;
                try {
                    window.webkit.messageHandlers.buttonClicked.postMessage({username: username, password: password});
                } catch(err) {
                    console.error('Error sending message to Swift: ' + err);
                }
            }, false);
        })();
        """

        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        
        // #Load WebPages in the following way
        // let url = URL(string: "https://localhost:3000/")!
        // webView.load(URLRequest(url: url))
        
        webView.navigationDelegate = self
    }


    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // #Custom command to consume the buttonClicked callback
        if message.name == "buttonClicked", let messageBody = message.body as? String {
            print("Received message from JavaScript: \(messageBody)")
        }
        
        if message.name == "buttonClicked", let formData = message.body as? [String: Any] {
            let username = formData["username"] as? String ?? ""
            let password = formData["password"] as? String ?? ""
            print("Username: \(username), Password: \(password)")
            setUsernameInWebView(username: "Tejas") //Invoke
        }
    }
    
    func setUsernameInWebView(username: String) {
        let script = "document.getElementById('username-field').value = '\(username)';"
        webView.evaluateJavaScript(script) { (result, error) in
            if let error = error {
                print("Error setting username: \(error)")
            } else {
                print("Username set successfully")
            }
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started loading")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!) {
        print("Failed loading")
    }


    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed loading with error: \(error)")
    }
}


