# Svelte ❤️ ReScript

This project is to demonstrate how to build Svelte apps using Rescript

## Get started

1. Clone the project
2. Install the dependencies...
```bash
$ npm i
```
3. Start the Svelte dev server and ReScript build system
```bash
$ npm run dev # to run the Svelte dev server
$ npm run re:watch # to run the ReScript Build System
```

## How it works
- The code written in ReScript is compiled to javascript file (by ReScript build system) which is imported in the *.svelte file. 
- So, in Svelte file we have html, css, and javascript code to subscribe to Svelte store (written in Rescript)
- All the logic like calling external API, updating the store and other logic can be written in ReScript.
- Note: You can't write ReScript in *.svelte file itself.

---

See also: [6020]: https://github.com/sveltejs/svelte/issues/6020


