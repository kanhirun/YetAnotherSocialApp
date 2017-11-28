import UIKit
import Nimble

public func beDisabled() -> Predicate<UIControl> {
    return Predicate.simple("be disabled") { actual -> PredicateStatus in
        return PredicateStatus(bool: try actual.evaluate()?.isEnabled == false)
    }
}
