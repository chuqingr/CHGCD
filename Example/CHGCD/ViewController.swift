//
//  ViewController.swift
//  CHGCD
//
//  Created by 杨胜浩 on 08/25/2018.
//  Copyright (c) 2018 杨胜浩. All rights reserved.
//

import UIKit
import CHGCD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        gcdTimerUse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ViewController {
    private func gcdQueueUse() {
        // Excute in main queue.
        GCDQueue.main.excute {
            print("GCDQueue.Main.excute")
        }

        // Excute in global queue.
        GCDQueue.global().excute {
            print("GCDQueue.Global().excute")
        }

        // Excute in concurrent queue.
        GCDQueue.concurrent().excute {
            GCDQueue.global().excuteAndWaitsUntilTheBlockCompletes {
                print("🔥 01")
            }

            GCDQueue.global().excuteAndWaitsUntilTheBlockCompletes {
                print("🔥 02")
            }

            GCDQueue.global().excuteAndWaitsUntilTheBlockCompletes {
                print("🔥 03")
            }

            GCDQueue.global().excuteAndWaitsUntilTheBlockCompletes {
                print("🔥 04")
            }
        }

        // GCDQueue excute in global queue after delay 2s.
        GCDQueue.global().excuteAfterDelay(2) {
            print("GCDQueue.Global().excuteAfterDelay 2 Seconds")
        }
    }

    private func gcdSerialQueueUse() {
        let serialQueue = GCDQueue.serial()

        serialQueue.excute {
            for i in 0..<10 {
                print("🔥" + String(i))
            }
        }

        serialQueue.excute {
            for i in 0..<10 {
                print("❄️" + String(i))
            }
        }
    }

    private func gcdConcurrentQueueUse() {
        let concurrentQueue = GCDQueue.concurrent()
        concurrentQueue.excute {
            for i in 0..<10 {
                print("🔥" + String(i))
            }
        }

        concurrentQueue.excute {
            for i in 0..<10 {
                print("❄️" + String(i))
            }
        }
    }

    private func gcdGroupNormalUse() {

        // Init group.
        let group = GCDGroup()

        // Excute in group.
        GCDQueue.global().excuteInGroup(group) {
            print("Do work A.")
        }

        // Excute in group.
        GCDQueue.global().excuteInGroup(group) {
            print("Do work B.")
        }

        // Excute in group.
        GCDQueue.global().excuteInGroup(group) {
            print("Do work C.")
        }

        // Excute in group.
        GCDQueue.global().excuteInGroup(group) {
            print("Do work D.")
        }

        // Notify in queue by group.
        group.notifyIn(GCDQueue.main) {
            print("Finish.")
        }
    }

    private func gcdGroupEnterAndLeaveUse() {
        // Init group.
        let group = GCDGroup()

        group.enter()
        group.enter()
        group.enter()

        print("Start.")

        GCDQueue.excuteInGlobalAfterDelay(3) {
            print("Do work A.")
            group.leave()
        }

        GCDQueue.excuteInGlobalAfterDelay(4) {
            print("Do work B.")
            group.leave()
        }

        GCDQueue.excuteInGlobalAfterDelay(2) {
            print("Do work C.")
            group.leave()
        }

        // Notify in queue by group.
        group.notifyIn(GCDQueue.main) {
            print("Finish.")
        }
    }

    private func gcdGroupWaitUse() {

        // Init group.
        let group = GCDGroup()
        group.enter()
        group.enter()

        print("Start.")

        GCDQueue.excuteInGlobalAfterDelay(3) {
            print("Do work A.")
            group.leave()
        }

        GCDQueue.excuteInGlobalAfterDelay(5) {
            print("Do work B.")
            group.leave()
        }

        let waitSeconds = arc4random() % 2 == 0 ? 4 : 6
        print("wait \(waitSeconds) seconds.")
        print(group.waitForSeconds(seconds: Float(waitSeconds)))
        print("wait finish.")

        // Notify in queue by group.
        group.notifyIn(GCDQueue.main) {
            print("Finish.")
        }
    }


    private func gcdSemaphoreWaitForeverUse() {

        // Init semaphore.
        let semaphore = GCDSemaphore()
        print("start.")

        GCDQueue.global().excute {
            semaphore.wait()
            print("Done 1")
            semaphore.wait()
            print("Done 2")
        }

        GCDQueue.global().excuteAfterDelay(3) {
            semaphore.signal()
        }

        GCDQueue.global().excuteAfterDelay(4) {
            semaphore.signal()
        }
    }

    private func gcdSemaphoreWaitSecondsUse() {
        // Init semaphore.
        let semaphore = GCDSemaphore()
        print("start.")
        GCDQueue.global().excute {
            _ = semaphore.waitForSeconds(3)
            print("Done")
        }

        GCDQueue.global().excuteAfterDelay(5) {
            print("signal")
            semaphore.signal()
        }
    }

    private func gcdTimerUse() {
        var count : Int = 0
        var gcdTimer : GCDTimer?

        gcdTimer = GCDTimerMaker.makeTimer(adding: 2, repeatInterval: 3, task: {
            count += 1
            print("\(count)")
            if count == 5 {
                print("suspend")
                gcdTimer?.suspend()
                GCDQueue.excuteInGlobalAfterDelay(2.0, {
                    print("start")
                    gcdTimer?.resume()
                })
            }
            if count >= 10 {
                gcdTimer?.cancel()
            }
        })

        print("Start.")
        gcdTimer?.resume()

        gcdTimer?.setDestroyEventHandler {

            print("Destroy event.")
        }
    }
}

