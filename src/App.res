
/**
* To acess Svelte writable, we need to define the module
**/
module Svelte = {
  type writable<'a> = {
    update: (('a) => 'a) => unit
  }
}
@bs.module("svelte/store") external writable: ('a) => Svelte.writable<'a> = "writable"


/**
* This is to access document.getElementById
* This is not used in this sample code
**/
type document
@bs.send external getElementById: (document, string) => Dom.element = "getElementById"
@bs.val external doc: document = "document"

/**
* To access the fetch method of the browser
* fetch: string => Js.Promise.t<option<Response.t>> = "fetch"
* "string" -- is the argument type of the fetch method
* "Js.Promise.t<option<Response.t>>" -- tells that the fetch method will return a promise of optional Response.t type
* "fetch" in the end is the keyword for the javascript function
* "Response.json" -- is a function that takes a "t" type and returns a promise string by calling the "json" javascript method (we can declare this outside of Response model as well)
**/
module Response = {
  type t
  @bs.send external json: t => Js.Promise.t<string> = "json"
}
@bs.val external fetch: string => Js.Promise.t<option<Response.t>> = "fetch"

/**
* The Svelte store which we use to store the state of the app
* These store are observerd in "App.svelte" file and state is update in "App.res" file
**/
let count = writable(0);
let randomNumber = writable(0);
let errorMessage = writable("");

/**
* This is a simple parse to parse the string response from the api
**/
let parser = (value: option<Response.t>): Js.Promise.t<string> => {
  switch (value) {
  | Some(res) => Response.json(res)
  | None => Js.Promise.resolve("Something went wrong")
  }
}

/**
* Execute the fech method to call the random number generator API
**/
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
      randomNumber.update((_) => newRandNumber)

      Js.Promise.resolve(true)
    }, _)
    ->Js.Promise.catch((_: Js.Promise.error) => {
      // We raised APIException, which gets converted to Js.Promise.error
      // No idea how to get the exception message from here, so now manually hardcoding the error message
      randomNumber.update((_) => 0)
      errorMessage.update((_) => {
        "The random number generator api is currently having a problem!"
      })
      Js.Promise.resolve(false)
    }, _)
}

/**
* This two methods are called from the App.svelte when the respective buttons are pressed
**/
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

// Note: All the method and variables are exported automatically by ReScript