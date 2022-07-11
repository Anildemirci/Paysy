//
//  Timer.swift
//  Paysy
//
//  Created by Anıl Demirci on 11.07.2022.
//

import Foundation

class TimerManager : ObservableObject {
    
    @Published var secondsElapsed = 0.0
    @Published var min=0
    @Published var hour=0
    
    var timer = Timer()
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.secondsElapsed += 0.1
            if self.secondsElapsed > 60.0  {
                self.min+=1
                if self.min > 60 {
                    self.hour+=1
                    self.min=0
                }
                self.secondsElapsed = 0.0
            }
        }
    }
}
