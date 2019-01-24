actor TinyPromise[A: Any #send, B: Any #send]
  let _resolve: {(A)} val
  let _reject: {(B)} val
  var state: TinyPromiseState = TinyPromiseRunning

  new create(resolve': {(A)} val, reject': {(B)} val) =>
    _resolve = resolve'
    _reject = reject'

  new from_receiver(receiver: TinyPromiseReceiver[A, B] val) =>
    _resolve = receiver~resolve()
    _reject = receiver~reject()

  be resolve(res: A) =>
    match state
    | TinyPromiseRunning =>
      _resolve(consume res)
      state = TinyPromiseResolved
    end

  be reject(err: B) =>
    match state
    | TinyPromiseRunning =>
      _reject(consume err)
      state = TinyPromiseRejected
    end


interface TinyPromiseReceiver[A: Any #send, B: Any #send]
  fun resolve(res: A)
  fun reject(err: B)


primitive TinyPromiseRunning
primitive TinyPromiseResolved
primitive TinyPromiseRejected
type TinyPromiseState is (TinyPromiseRunning | TinyPromiseRejected | TinyPromiseResolved)
