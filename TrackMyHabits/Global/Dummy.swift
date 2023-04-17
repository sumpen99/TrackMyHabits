//
//  Dummy.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

class Dummy{
    var name = ""
    var printOnDestroy = false
    init(name:String = "",printOnDestroy:Bool = false){
        self.name = name
        self.printOnDestroy = printOnDestroy
        if printOnDestroy{
            //printAny("init dummy name: \(name)")
        }
    }
    
    func printTest(){
        print(Unmanaged.passUnretained(self).toOpaque())
    }
    
    deinit{
        if printOnDestroy{
            //printAny("deinit dummy name: \(name)")
        }
    }
}
