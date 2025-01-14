import Combine
import Foundation

public enum Signpost {
  public static let prior = "signpost_prior"
  public static let modelUpdate = "signpost_model_update"
  public static let undoRedo = "signpost_undo_redo"
}

// MARK: - SigPostTransaction

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public final class SignpostTransaction: AnyTransaction {
  /// See `SignpostAction`.
  public let actionId: String

  public let id: String = PushID.default.make()

  public let strategy: Dispatcher.Strategy = .async(nil)

  /// - note: Never set because `SignpostTransaction`s do not have a backing operation.
  public var error: Dispatcher.TransactionGroupError? = nil

  /// - note: Never set because `SignpostTransaction`s do not have a backing operation.
  public var operation: AsyncOperation {
    fatalError("This transaction does not spawn any operation.")
  }

  /// No associated store ref.
  public var opaqueStoreRef: AnyStoreType? = nil

  /// Represents the progress of the transaction.
  public var state: TransactionState = .pending

  public func on(_ queueWithStrategy: Dispatcher.Strategy) -> Self {
    // No op.
    return self
  }

  init(singpost: String) {
    self.actionId = singpost
  }

  public func perform(operation: AsyncOperation) {
    // No op.
  }

  public func run(handler: Dispatcher.TransactionCompletionHandler) {
    // No op.
  }
}
