<script>
	import {
		count,
		randomNumber,
		incrementCount,
		decrementCount,
		generateRandomNumber,
		errorMessage
	} from './App.bs'

	// the `$:` means 're-run whenever these values change'
	$: doubled = count_value * 2;
	$: quadrupled = doubled * 2;

	let count_value;
	let random_number;
	let error_message;

	const unsubscribeCount = count.subscribe(value => {
		count_value = value;
	});

	const unsubscribeRandomNumber = randomNumber.subscribe(value => {
		random_number = value;
	});

	const unsubscribeErrorMessage = errorMessage.subscribe(value => {
		error_message = value;
	});

	export let name;
</script>

<main>
	<h1>Hello {name}!</h1>
	<p>Visit the <a href="https://svelte.dev/tutorial">Svelte tutorial</a> to learn how to build Svelte apps.</p>
	<p>Visit the <a href="https://rescript-lang.org/docs/manual/latest/introduction">Rescript manual</a> to learn Rescript.</p>


	<h3>{count_value}</h3>

	<button on:click={incrementCount}>Increase</button>
	<button on:click={decrementCount}>Decrease</button>

	<p>{count_value} * 2 = {doubled}</p>
	<p>{doubled} * 2 = {quadrupled}</p>

	<hr />
	<h3>Random Number from API</h3>
	<h3>{random_number}</h3>
	<p class="error-message">{error_message}</p>
	<button on:click={generateRandomNumber}>Random</button>

</main>

<style>
	main {
		text-align: center;
		padding: 1em;
		max-width: 240px;
		margin: 0 auto;
	}

	h1 {
		color: #ff3e00;
		text-transform: uppercase;
		font-size: 4em;
		font-weight: 100;
	}

	.error-message {
		color: #ff3e00;
	}

	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}
</style>