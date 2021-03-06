module Svelte = {
  type writable<'a> = {
    update: (('a) => 'a) => unit
  }
}

@bs.module("svelte/store") external writable: ('a) => Svelte.writable<'a> = "writable"

type document // abstract type for a document object
@bs.send external getElementById: (document, string) => Dom.element = "getElementById"
@bs.val external doc: document = "document"

module Response = {
  type t
  @bs.send external json: t => Js.Promise.t<string> = "json"
}

@bs.val external fetch: string => Js.Promise.t<option<Response.t>> = "fetch"

let count = writable(0);
let randomNumber = writable(0);
let errorMessage = writable("");

let parser = (value: option<Response.t>): Js.Promise.t<string> => {
  switch (value) {
  | Some(res) => Response.json(res)
  | None => Js.Promise.resolve("Something went wrong")
  }
}

let randomNumberAPI = () => {
  let myPromise = fetch("https://svelte.dev/tutorial/random-number")

  myPromise->Js.Promise.then_(value => {
    Js.log(value)
    Js.Promise.resolve(value)
  }, _)
}

let fetchRandomNumber = () => {
  randomNumberAPI()
    ->Js.Promise.then_(value => parser(value), _)
    ->Js.Promise.then_(body => {
      Js.log(body)
      Js.Promise.resolve(body)
    }, _)
}

exception APIException(string)

let generateRandomNumber = () => {
  fetchRandomNumber()
    ->Js.Promise.then_(data => {

      let newRandNumber = switch (Belt.Int.fromString(data)) {
        | Some(data) => data
        | None => raise(APIException(data))
      }

      errorMessage.update((_) => "")
      randomNumber.update((_) =>newRandNumber)

      Js.Promise.resolve(true)
    }, _)
    ->Js.Promise.catch((_: Js.Promise.error) => {
      randomNumber.update((_) => 0)
      errorMessage.update((_) => {
        "The random number generator api is currently having a problem!"
      })
      Js.Promise.resolve(false)
    }, _)
}

let incrementCount = () => {
  Js.log("calling -- incrementCount()")
  count.update((value) => {
    value + 1
  })
}

let decrementCount = () => {
  Js.log("calling -- decrementCount()")
  count.update((value) => {
    value -1
  })
}