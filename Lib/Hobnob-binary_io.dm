/*
 *  Binary I/O v1.1 by Hobnob
 *  Requires the "dm_file.dll" DLL present
 *
 *	Provides C-style file I/O routines with binary access.
 *	via an interface to an external DLL library.
 */

/*
 *	Usage:
 *
 *	To initiate binary I/O, first create an instance of the binfile datum:
 *
 *  	var/binfile/B = new()
 *
 *	This doesn't perform any file operations, but merely creates the interface to the external library.
 *  The datum holds the handle of the opened file and allows access to the C-style IO functions on that file.
 *  You may create as many binfile datums as you wish if you require multiple simultaneously open files.
 *
 *	To open a file, use the binfile open() proc:
 *
 *		B.open("filename,txt")
 *
 *	This defaults to file mode "rb+", allowing you to read and write from an existing file in binary mode.
 *  To use another mode, append an argument for the mode string:
 *
 * 		B.open("filenmame.txt", "wa")
 *
 *	See the C fopen() documentation for all possible mode settings.
 *
 *	A convenience proc exists for when you wish to create a new file:
 *
 *		B.create("filename.txt")
 *
 *	This is equivalent to B.open("filename.txt", "wb+"), which creates a new file (or truncates it if already existing),
 *  and then allows reading and writing in binary mode.
 *
 *	Both open() and create() return 0 to flag an error condition, TRUE if the operation was successful.
 *
 *	With the file open, various reading and writing procs can be called:
 *
 *	Reading:-
 *
 *	string = B.getstring(max)
 *		Read "max" characters from the file, or until a newline or end of file is encountered
 *
 *	value = B.getbyte()
 *		Read a single byte
 *
 *	value = B.getword()
 *		Read a two-byte word. By default, read in little-endian (low, high-byte) order. Use:
 *	value = B.getword(1)
 *		To read in big-endian (high, low-byte) order
 *
 *	valuelist = B.read(count)
 *		Read "count" bytes from the file, and return them as a /list of byte values.
 *
 *	Writing:-
 *
 *	B.putstring(string)
 *		Write a string to the file.
 *
 *	B.putbyte(value)
 *		Write a byte value to the file.
 *
 *	B.putword(value)
 *		Write a two-byte (word) value to the file. By default, uses little_endian (low, high-byte) order. Use:
 *	B.putword(value, 1)
 *		To write in big-endian (high, low-byte) order.
 *
 *	B.write(datalist)
 *		Write a /list of byte values to the file.
 *
 *
 *	Other operations:-
 *
 *	To close the file, use:
 *
 *		B.close()
 *
 *	This finalizes all file operations and closes the file. You may not use any other file operations after close() is
 *	called (except that you may reuse the same binfile datum to open() or create() another file).
 *	You should close the file once all operations are complete, and also before you attempt any of the standard DM file
 *  operations (fcopy, etc.) on the same file.
 *
 *	Note that is the binfile datum is deleted, any open file is automatically closed.
 *
 *	If you wish to switch between write and read operations on the same file, call flush()
 *
 *		B.flush()
 *
 *	This ensures that all write operations have completed and are written to disk.
 *
 *	The end of file condition is found with:
 *
 *		end = B.eof()
 *
 *	This return TRUE (1) if the file is currently at the end-of-file marker, FALSE (0) otherwise.
 *
 *	To find the actual read/write position in the file, use:
 *
 *		pos = B.tell()
 *
 *	This value is the byte offset from the start of the file (n.b. but only if the file is opened in binary mode)
 *
 *	To reposition the read/write position, use:
 *
 *		B.seek(pos)
 *
 *	This moves the read/write position "pos" bytes forward in the file. A negative value for "pos" moves the file
 *  position backward. An optional seek type parameter can be used:
 *
 *		B.seek(pos, seek_type)
 *
 *	Where seek_type is one of:
 *	SEEK_CUR:	Default as above - move "pos" bytes relative to current file position.
 *	SEEK_END:	Move to position "pos" bytes from the end of the file.
 *  SEEK_SET:	Move to position "pos" bytes from the start of file. Note this is the same value as returned by tell().
 *
 *
 *	If an error occurred during a file operation, this is usually flagged by a return value of 0 (FALSE), or for functions
 *  that can return 0 in normal operation (get..() functions and tell()), the null value. In this case, the actual error
 *	condition can be found with:
 *
 *		errornum = B.error()
 *
 *	This returns the number of the last error that occured during a file operation, or 0 for no error. To return a string
 *  describing the error, use the function:
 *
 *		errorstr = B.error_string()
 *
 *	The returned string shows the function that failed and the cause of the error.
 *
 *
 */


#define DMFILEDLL "Lib/dm_file"

#define SEEK_CUR "C"
#define SEEK_END "E"
#define SEEK_SET "S"

binfile
	var/handle	= null		//the file handle string - null if PIPE_INVALID

	// Called when a binfile datum is deleted
	// If the file handle is still valid, close the file.
	Del()
		if(handle)
			close()


	proc

		// Open a file with the given filename and mode settings.
		// The default mode is "rb+", allowing you to read and write from an existing file in binary mode.
		// If the file does not exist, the proc fails
		// Returns 0 to signal an error condition (such as the file does not exist or is PIPE_INVALID)

		// note see C/C++ fopen() documentation for other mode settings

		open(filename, mode="rb+")

			handle = call(DMFILEDLL, "file_open")(filename, mode)

			if(handle=="-1")
				return 0
			return 1


		// Create a file. Convenience routine equivalent to open(filename, "wb+")
		// Same as open(), but the default mode is "wb+", which allows reading and writing in binary mode.
		// If the file does not exist, it is created.
		// If the file already exists, it is truncated

		create(filename)

			return open(filename, mode="wb+")


		// Close the file.
		// Should be called after all reads and writes are completed. This PIPE_INVALIDates the file handle.
		// Should also be called before any standard DM file i/o is attempted on the same file.

		close()

			if( call(DMFILEDLL, "file_close")(handle) == "-1")
				return 0

			handle = null

			return 1

		// Flush the buffers associated with the file.
		// Should be called before switching between writing and reading data from the same file.

		flush()
			if( call(DMFILEDLL, "file_flush")(handle) == "-1")
				return null
			return 1

		// Returns TRUE if the file position is at the end of the file

		eof()

			if( call(DMFILEDLL, "file_eof")(handle) == "0")
				return 0
			return 1


		// Get a string from the file and returns it
		// Reads until the first newline, the end of file, or until "max" characters has been read.
		// Returns null if an error occurred.

		getstring(var/max)

			var/result = call(DMFILEDLL, "file_gets")(handle, "[max]")

			if(result=="-1")
				return null

			return result


		// Write a string to the file
		// Returns FALSE if an error occurred

		putstring(var/str)

			if( call(DMFILEDLL, "file_puts")(handle, str) == "-1")
				return 0

			return 1

		// Read a single byte from the file
		// Returns the byte, or null if an error occurred.

		getbyte()

			var/result = call(DMFILEDLL, "file_getbyte")(handle)

			if(result=="-1")
				return null

			return text2num(result)

		// Write a single byte to the file
		// Return FALSE if an error occurred.

		putbyte(var/byte)

			var/result = call(DMFILEDLL, "file_putbyte")(handle, "[byte]")

			if(result=="-1")
				return 0

			return 1


		// Read a two-byte word from the file
		// Returns the word value, or null if error.
		// Set the optional parameter to non-zero to read in big-endian order (high-byte, low-byte)
		// Otherwise the default is little-endian order (low-byte, high-byte)

		getword(var/bigendian=0)

			var/result
			if(bigendian)
				result = call(DMFILEDLL, "file_getword")(handle, "B")
			else
				result = call(DMFILEDLL, "file_getword")(handle, "L")

			if(result == "-1")
				return null

			return text2num(result)


		// Write a two-byte word to the file
		// Returns FALSE if an error occurred.
		// Set the optional parameter to non-zero to write in big-endian order (high-byte, low-byte)
		// Otherwise the default is little-endian order (low-byte, high-byte)

		putword(var/word, var/bigendian=0)

			var/result
			if(bigendian)
				result = call(DMFILEDLL, "file_putword")(handle, "[word]", "B")
			else
				result = call(DMFILEDLL, "file_putword")(handle, "[word]", "L")

			if(result=="-1")
				return 0

			return 1


		// Return the current file position, usually the byte offset from the start of the file
		// Returns null if an error occurred

		tell()
			var/pos = call(DMFILEDLL, "file_tell")(handle)


			if(pos == "-1")
				return null

			return text2num(pos)


		// Set the current file position
		// "origin" is one of:
		// SEEK_CUR (default) - "pos" is the change from current file position
		// SEEK_END - "pos" is from end of file
		// SEEK_SET - "posn" is from start of file

		seek(var/pos, var/origin=SEEK_CUR)

			var/result = call(DMFILEDLL, "file_seek")(handle, "[pos]", origin)

			if(result == "-1")
				return null

			return 1


		// read "count" bytes from the file
		// returns the result as a list of numbers

		read(var/count)

			var/result = call(DMFILEDLL, "file_read")(handle, "[count]")

			if(result == "-1")
				return null

			var/list/ret = new			// the returned list of bytes

			var/i = 2;					// skip initial "0" in return string

			// decode returned string
			// 0, 0x1B and 0xFF are escaped with a preceeding 0x1B (ESC)
			// then 1 -> 0, 2->0xFF, 0x1B -> 0x1B
			// this is done because of the limited string interface between DM and a DLL

			while(i<=length(result))
				var/c = text2ascii(result, i);

				if(c==0x1B)			// if ESC char, next char is the actual byte
					i++
					c = text2ascii(result, i);

					if(c==1)
						c=0
					else if(c==2)
						c=0xFF

				ret.Add(c);
				i++

			return ret

		// write a list of bytes to the file

		write(var/list/data)

			// convert the data into an encoded string

			var/datastr = ""

			for(var/byte in data)
				if(byte == 0)
					datastr += ascii2text(0x1B) + ascii2text(1)
				else if(byte==0xFF)
					datastr += ascii2text(0x1B) + ascii2text(2)
				else if(byte==0x1B)
					datastr += ascii2text(0x1B) + ascii2text(0x1B)
				else
					datastr += ascii2text(byte)

			if( call(DMFILEDLL, "file_write")(handle, datastr, "[length(datastr)]") == "-1")
				return 0

			return 1




		// Returns the last error code
		// 0 = no error
		// 1 = DLL function called with wrong number of paramters
		// 2 = failed to open file
		// 3 = unknown file handle
		// 4 = failed to close file
		// 5 = end of file reached
		// 6 = PIPE_INVALID file seek/tell
		// 7 = PIPE_INVALID seek origin
		// 8 = malloc failed (out of memory/heap space)
		// 9 = read failure
		// 10 = write failure


		error()
			var/result = call(DMFILEDLL, "last_error")()

			return text2num(result)


		// Returns a string describing the last error code

		error_string()
			var/result = call(DMFILEDLL, "last_error_str")()

			return result

		// Return the DLL version string

		version()
			return call(DMFILEDLL, "version")()

