

import UIKit

class FavSound: NSObject {
    
    
    var sid:String! = ""
    var thum:String! = ""
    var sound_name:String! = ""
    var audio_path:String! = ""
    var descri:String! = ""
   
    
    init(sid: String!, thum: String!, sound_name: String!,audio_path: String!, descri: String!) {
        
        self.sid = sid
        self.thum = thum
        self.sound_name = sound_name
        self.audio_path = audio_path
        self.descri = descri
    
        
    }
}
