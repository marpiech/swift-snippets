//: # Swift 3: URLSessionDelegate
//: The following example shows how to use `OperationQueue` to queue the network requests. This is useful in many ways (for delaying queued requests when the networking goes down for example)

import Foundation
import PlaygroundSupport

class Requester:NSObject {
    
    let opQueue = OperationQueue()
    var response:URLResponse?
    var session:URLSession?
    
    var time:DispatchTime! {
        return DispatchTime.now() + 1.0 // seconds
    }
    
    func request() {
        print("Requesting...")
        // suspend the OperationQueue (operations will be queued but won't get executed)
        self.opQueue.isSuspended = true
        let sessionConfiguration = URLSessionConfiguration.default
        // disable the caching
        sessionConfiguration.urlCache = nil
        
        // initialize the URLSession
        self.session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: self.opQueue)
        //self.session
        
        // create a URLRequest with the given URL and initialize a URLSessionDataTask
        if let url = URL(string: "https://178.216.202.134:10667/api/users") {
            let request = URLRequest(url: url)
            if let task = self.session?.dataTask(with: request) {
                // start the task, tasks are not started by default
                task.resume()
            }
        }
        
        // Open the operations queue after 1 second
        DispatchQueue.main.asyncAfter(deadline: self.time, execute: {[weak self] in
            print("Opening the OperationQueue")
            self?.opQueue.isSuspended = false
        })
        
        /*var configuration =
            URLSessionConfiguration.default
        
        var session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
        
        let url = URL(string: "https://178.216.202.134:10667/api/users")
        let request = URLRequest(url: url!)
        
        var task = session.dataTask(with: request) {
            data, response, error in
            if error == nil {
                var result = NSString(data: data!, encoding:
                    String.Encoding.utf8.rawValue)!
                NSLog("result %@", result)
            }
        }
        task.resume()*/
        
    }
}

extension Requester:URLSessionDelegate {
    
    /*func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // We've got a URLAuthenticationChallenge - we simply trust the HTTPS server and we proceed
        print("didReceive challenge")
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        
        //completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }*/
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        print("session1")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
        print("session2")
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        //print("session3")
        
        //NAJWAZNIEJSZE
        
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        // We've got an error
        if let err = error {
            print("Error: \(err.localizedDescription)")
        } else {
            print("Error. Giving up")
        }
        PlaygroundPage.current.finishExecution()
    }
    
    
    /*func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        //accept all certs when testing, perform default handling otherwise
        if webService.isTesting() {
            print("Accepting cert as always")
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
        else {
            print("Using default handling")
            completionHandler(.performDefaultHandling, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }*/
    
}

extension Requester:URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        // The task became a stream task - start the task
        print("didBecome streamTask")
        streamTask.resume()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        // The task became a download task - start the task
        print("didBecome downloadTask")
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // We've got a URLAuthenticationChallenge - we simply trust the HTTPS server and we proceed
        print("didReceive challenge")
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: (URLRequest?) -> Void) {
        // The original request was redirected to somewhere else.
        // We create a new dataTask with the given redirection request and we start it.
        if let urlString = request.url?.absoluteString {
            print("willPerformHTTPRedirection to \(urlString)")
        } else {
            print("willPerformHTTPRedirection")
        }
        if let task = self.session?.dataTask(with: request) {
            task.resume()
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // We've got an error
        if let err = error {
            print("Error: \(err.localizedDescription)")
        } else {
            print("Error. Giving up")
        }
        PlaygroundPage.current.finishExecution()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Void) {
        // We've got the response headers from the server.
        print("didReceive response")
        self.response = response
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // We've got the response body
        print("didReceive data")
        if let responseText = String(data: data, encoding: .utf8) {
            print(self.response)
            print("\nServer's response text")
            print(responseText)
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //if let firstCategory = json["categories"]??[0]["name"] as? String {
            let id = json
            print(id)
                print("The first category in the JSON list is is")
            // TUTAJ TO TRZEBA POROZBIERAC
            
            //}
        } catch let error as NSError {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
        
        self.session?.finishTasksAndInvalidate()
        PlaygroundPage.current.finishExecution()
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
let requester = Requester()
requester.request()

