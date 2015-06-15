/**
 * @file hooks.dm
 * Implements hooks, a simple way to run code on pre-defined events.
 */

/** @page hooks Code hooks
 * @section hooks Hooks
 * A hook is defined under /hook in the type tree.
 *
 * To add some code to be called by the hook, define a proc under the type, as so:
 * @code
	/hook/foo/proc/bar()
		if(1)
			return 1 //Sucessful
		else
			return 0 //Error, or runtime.
 * @endcode
 * All hooks must return nonzero on success, as runtimes will force return null.
 */

/**
 * Calls a hook, executing every piece of code that's attached to it.
 * @param hook	Identifier of the hook to call.
 * @returns		1 if all hooked code runs successfully, 0 otherwise.
 */

/hook/game_start
/hook/startup