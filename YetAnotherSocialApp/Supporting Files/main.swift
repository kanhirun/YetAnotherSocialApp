/*!
 Taken from https://qualitycoding.org/app-delegate-for-tests/
 Author: Jon Reid
 */

import UIKit

let appDelegateClass: AnyClass? = NSClassFromString("YetAnotherSocialAppTests.TestAppDelegate") ?? AppDelegate.self
let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
    .bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))

UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(appDelegateClass!))
