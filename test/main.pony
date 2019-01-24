use "time"
use "../"

actor Main
  let env: Env
  new create(env': Env) =>
    env = env'
    let bowl = FruitBowl
    let receiver = MyReceiver(this)
    bowl.grab_fruit(TinyPromise[Fruit tag, Error tag].from_receiver(receiver))

  be task_end(fruit: Fruit tag) =>
    match fruit
    | let x: Apple tag => env.out.print("It is an apple!")
    | let x: Banana tag => env.out.print("It is a banana!")
    end

  be task_error(err: Error tag) =>
    env.out.print("Uh oh! Looks like we got ourselves an error!")


actor FruitBowl
  be grab_fruit(promise: TinyPromise[Fruit tag, Error tag] tag) =>
    let task = FruitGrabbingTask(promise)
    Timers()(Timer(consume task, 2_000_000_000))


primitive Apple
primitive Banana
type Fruit is (Apple tag | Banana tag)
primitive Error


class MyReceiver is TinyPromiseReceiver[Fruit tag, Error tag]
  let _parent: Main tag

  new val create(parent: Main tag) =>
    _parent = parent

  fun resolve(fruit: Fruit tag) =>
    _parent.task_end(fruit)

  fun reject(err: Error tag) =>
    _parent.task_error(err)


class FruitGrabbingTask is TimerNotify
  let _promise: TinyPromise[Fruit tag, Error tag] tag
  new iso create(prom: TinyPromise[Fruit tag, Error tag] tag) =>
    _promise = prom

  fun apply(t: Timer, count: U64): Bool =>
    _promise.resolve(Banana)
    false
