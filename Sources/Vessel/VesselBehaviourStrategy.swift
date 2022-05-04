import Foundation

/// A type used when performing operations or modifying behaviours that exposes a function to mutate an array of behaviours
public struct VesselBehaviourStrategy {

    /// A function that takes an array of behaviour, optionally mutates it, and returns a new array of behaviours
    var include: ([VesselBehaviour]) -> [VesselBehaviour]
}

extension VesselBehaviourStrategy {

    /// A preset that does not mutate the array of behaviours
    public static var all: VesselBehaviourStrategy { .init { $0 } }

    /// A preset that excludes all behaviours
    public static var none: VesselBehaviourStrategy { .init { _ in [] } }

    /// A preset that excludes a certain type of behaviours
    /// - Parameter behaviours: The type of behaviours to exclude
    /// - Returns: A mutated array excluding all behaviours of the given type
    public static func exclude(_ behaviours: [VesselBehaviour.Type]) -> VesselBehaviourStrategy {
        .init { existing in
            existing.filter { behaviour in
                !behaviours.contains { type(of: behaviour) == $0 }
            }
        }
    }

    /// A preset that excludes specific instances of behaviours
    /// - Parameter behaviours: The instances of behaviours to exclude
    /// - Returns: A mutated array excluding all given instances of behaviours
    public static func exclude(_ behaviours: [VesselBehaviour]) -> VesselBehaviourStrategy {
        .init { existing in
            existing.filter { behaviour in
                !behaviours.contains { behaviour === $0 }
            }
        }
    }

    /// A preset that includes only behaviours of the given type
    /// - Parameter behaviours: The only type of behaviour to include
    /// - Returns: A mutated array containg only the given types of behaviours
    public static func only(_ behaviours: [VesselBehaviour.Type]) -> VesselBehaviourStrategy {
        .init { existing in
            existing.filter { behaviour in
                behaviours.contains { type(of: behaviour) == $0 }
            }
        }
    }

    /// A preset that includes only the given instances of behaviours
    /// - Parameter behaviours: The only instances of behaviours to include
    /// - Returns: A mutated array containing only the given instances of behaviours
    public static func only(_ behaviours: [VesselBehaviour]) -> VesselBehaviourStrategy {
        .init { _ in behaviours }
    }

    /// A preset that appends behaviours at the end of the input behaviours
    /// - Parameter behaviours: The instances to append at the end
    /// - Returns: A mutated array with appended behaviours
    public static func appending(_ behaviours: [VesselBehaviour]) -> VesselBehaviourStrategy {
        .init { $0 + behaviours }
    }

    /// A preset that prepends behaviours at the beginning of the input behaviours
    /// - Parameter behaviours: The instaces to prepend at the beginning
    /// - Returns: A mutated array with prepended behaviours
    public static func prepending(_ behaviours: [VesselBehaviour]) -> VesselBehaviourStrategy {
        .init { behaviours + $0 }
    }

    /// A preset that replaces the first instance of a given type with another instance
    ///
    /// Appends the new instance if no instances of the given type is found.
    ///
    /// - Parameters:
    ///   - type: The type of behavior to replace
    ///   - behaviour: The instance to replace the one found
    /// - Returns: A mutated array containing the new instance
    public static func replaceFirst<T: VesselBehaviour>(_ type: T.Type = T.self, with behaviour: T) -> VesselBehaviourStrategy {
        .init { behaviours in

            guard let index = behaviours.firstIndex(where: { $0 is T }) else {
                return behaviours + [behaviour]
            }

            var updated = behaviours
            updated[index] = behaviour

            return updated
        }
    }
}
