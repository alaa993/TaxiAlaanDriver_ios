//
//  MqttContection.swift
//  mqttObjectc
//
//  Created by kavoskhajavi on 10/24/19.
//  Copyright © 2019 kavoskhajavi. All rights reserved.
//
import MQTTClient
import AVFoundation
import UserNotifications
class MqttContection: NSObject,UNUserNotificationCenterDelegate {
    
    private let session = MQTTSession()!
    let defaultHost = "3.120.201.222"
    var player: AVAudioPlayer?

    
    override init() {
        super.init()
      UNUserNotificationCenter.current().delegate = self
    }
    
    @objc
    func connect()  {
        
        configMqtt()
        
    }
    
    @objc
    func conectMqtt(){
        
      
        let offline = ["status":0,"provider_id":UserDefaults.standard.integer(forKey: "id")]
        
        session.transport = MQTTCFSocketTransport()
        session.transport.host = UserDefaults.standard.string(forKey:"ip") ?? ""

        session.transport.port = UInt32(UserDefaults.standard.integer(forKey:"port"))
       
        session.delegate = self
        
        session.willFlag = true
        session.willTopic = "PROD/Provider/Status"
        session.willMsg = convert(A: offline).data(using:.utf8)
        session.willQoS = .exactlyOnce
        
        
        session.connect()
        
    }
    
    
    func configMqtt(){
        
        ServiceAPI
            .shared
            .fetchGenericData(urlString: CONFIGMQTT,parameters: [:],methodInput: .get, isHeaders: true){ (model:ModelConfig?,error:Error?,status:Int?) in
                
                if error != nil {
                    self.configMqtt()
                    return
                }
                
                UserDefaults.standard.set(model?.mqtt?.port, forKey: "port")
                UserDefaults.standard.set(model?.mqtt?.server, forKey: "ip")
                
                self.conectMqtt()
                
        }
        
    }
    
    
    func convert(A:[String:Any]) -> String {
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: A, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {
           return theJSONText
        }
        return ""
    }
}




extension MqttContection:MQTTSessionDelegate {
    
    func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
        
        switch eventCode {
        case .connected:
            print("Connected")
            subscribed()
            pushOnline()
        case .connectionClosed:
            print("Closed")
            connect()
        case .connectionClosedByBroker:
            print("Closed by Broker")
            connect()
        case .connectionError:
            connect()
            print("Error")
        case .connectionRefused:
            print("Refused")
            connect()
        case .protocolError:
             connect()
        }
    }
    
    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        
        print("\n topic - \(topic!) data - \(data!)")
        let  jsonDecoder = JSONDecoder()
        guard let data = data else { return }

        do {

            let json = try jsonDecoder.decode(ModelResponseMqtt.self, from: data)
            if json.status == 1 {
                 authorized()
            } else if json.status == 2
                && json.token == UserDefaults.standard.string(forKey:"access_token") {

                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                exit(0)

            }


        }catch let error{
            print(error)

        }
        
        
    }
    
    func playSound(){
        let sound = Bundle.main.url(forResource: "alert", withExtension: "wav")
        do {
            player = try AVAudioPlayer(contentsOf: sound!)
            guard let player = player else { return }
            player.prepareToPlay()
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
                print("Playback OK")
                try AVAudioSession.sharedInstance().setActive(true)
                print("Session is Active")
            } catch {
                print(error)
            }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }

    func subscribed()  {
        
        let id =  UserDefaults.standard.integer(forKey: "id")
        session.subscribe(toTopic: "PROD/Request/\(id)", at: .atMostOnce)
        
    }
    
    @objc
    func pushMassage(topic:String,message:String) {
        
        session.publishData(message.data(using: String.Encoding.utf8), onTopic: topic, retain: false, qos: .atMostOnce)
       // scheduleLocalNotification()
        
        
    }
    
    @objc
    func pushOnline() {
        
        _ = "{status:1,provider_id:\(UserDefaults.standard.integer(forKey: "id"))}"
        
          let online = ["status":1,"provider_id":UserDefaults.standard.integer(forKey: "id")]
        
        session.publishData(convert(A: online).data(using: String.Encoding.utf8), onTopic:"PROD/Provider/Status", retain: true, qos: .exactlyOnce)
        
    }
    
    func checkStatusApp() -> Bool {
        
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive {
            return true
        } else if state == .active {
            return false
        }
        return false
    }
    
    
     func authorized() {
         // Request Notification Settings
         UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
             switch notificationSettings.authorizationStatus {
             case .notDetermined:
                 self.requestAuthorization(completionHandler: { (success) in
                     guard success else { return }
                     self.scheduleLocalNotification()
                     self.playSound()
                 })
             case .authorized:
                 self.scheduleLocalNotification()
                 self.playSound()
             case .denied:
                 print("Application Not Allowed to Display Notifications")
             case .provisional:
                 print("provisional")
             @unknown default:
                 print("provisional")
             }
         }
     }
    
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        NSLog("userInfoibrahim1->%s", "requestAuthorization");
          // Request Authorization
          UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
              if let error = error {
                  print("Request Authorization Failed (\(error), \(error.localizedDescription))")
              }

              completionHandler(success)
          }
      }
    
    
    private func scheduleLocalNotification() {
        NSLog("userInfoibrahim2->%s", "scheduleLocalNotification");
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()

        // Configure Notification Content
        notificationContent.title = "TaxiAlaan"
        notificationContent.subtitle = "Accept travel"
        notificationContent.body = ""

        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)

        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)

        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
}

extension MqttContection {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NSLog("userInfoibrahim3->%s", "userNotificationCenter");
        completionHandler([.alert])
    }
    
}
