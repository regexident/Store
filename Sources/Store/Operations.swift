import Foundation

@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public class TransactionOperation<T: AnyTransaction>: AsyncOperation {
  /// The associated transaction.
  public let transaction: T

  /// The completion block type for this operation.
  /// - note: Internal only.
  var finishBlock: CompletionBlock = {}

  /// Constructs a new action operation.
  /// - parameter transaction: The transaction for this operation.
  public init(transaction: T) {
    self.transaction = transaction
  }

  /// Subclasses are expected to override the ‘execute’ function and call the function ‘finish’
  /// when they’re done with their task.
  public override func execute() {
    guard !isCancelled else {
      finish()
      return
    }
    transaction.state = .started
    transaction.perform(operation: self)
  }

  /// This function should be called inside ‘execute’ when the task for this operation is completed.
  override public func finish() {
    transaction.state = isCancelled ? .canceled : .completed
    finishBlock()
    super.finish()
  }
}

/// Base class for an asynchronous operation.
/// Subclasses are expected to override the 'execute' function and call
/// the function 'finish' when they're done with their task.
@available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *)
public class AsyncOperation: Operation {
  /// The completion block type for this operation.
  public typealias CompletionBlock = () -> Void

  // Internal properties override.
  @objc dynamic override public var isAsynchronous: Bool { return true }

  @objc dynamic override public var isConcurrent: Bool { return true }
  @objc dynamic override public var isExecuting: Bool { return __executing }
  @objc dynamic override public var isFinished: Bool { return __finished }

  // __ to avoid name clashes with the superclass.
  @objc dynamic private var __executing = false {
    willSet { willChangeValue(forKey: "isExecuting") }
    didSet { didChangeValue(forKey: "isExecuting") }
  }

  // __ to avoid name clashes with the superclass.
  @objc dynamic private var __finished = false {
    willSet { willChangeValue(forKey: "isFinished") }
    didSet { didChangeValue(forKey: "isFinished") }
  }

  /// Begins the execution of the operation.
  @objc dynamic public override func start() {
    __executing = true
    execute()
  }

  /// Subclasses are expected to override the 'execute' function and call
  /// the function 'finish' when they're done with their task.
  @objc public func execute() {
    fatalError("Your subclass must override this")
  }

  /// This function should be called inside 'execute' when the task for this
  /// operation is completed.
  @objc dynamic public func finish() {
    __executing = false
    __finished = true
  }
}
