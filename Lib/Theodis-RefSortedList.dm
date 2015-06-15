/*

RefSortedList

This is a list that works much like normal lists in BYOND which the exception
that the contained items are kept sorted by their ref value.  This has several
advantages and disadvantages and when used properly can lead to large
performance increases.

Its advantages are
Much faster find times
Much faster removal times
Much easier to find and remove duplicates

Its disadvantages are
The order of the list must be kept otherwise find and remove procs won't work
properly.
Adding items is slower

Since the order of the items must remain sorted you should never manipulate the
contents variable in anyway that would change order.  The easiest way this can
happen accidently is if an item in the list is deleted and not removed as it'll
become a null reference.  So you should always first remove an item before
deleting it.  If you are unable to do this and the list order gets corrupted
just call Fix() and the list will sort itself out properly again.  Other than
that as long as you use the RefSortedList list procs instead of the contents
list procs everything should remain ok.

Because the list order must remain sorted Insert and Swap procs were not
implemented.

Many of the procs have an exact version of them(ie Add and AddExact, Remove and
RemoveExact, etc). To work like the base list class provided by BYOND if you
pass a list into Add or Remove it adds or removes the items contained in the
list rather than the list reference itself.  The exact versions of the procs do
not do this instead just add or remove the references of the encountered lists.
Because of this there is less overhead in the Exact procs so those will be
faster and should be used unless you want the list items to be added rather than
the list itself.

Usage
contents - The underlying list of the class use it to access the items in the
list but don't mess with their order or alter them in some way that would change
their reference.

New(l[])

l - The base list to build off of.  It can be null.

The base constructor for the class creates an empty list if null is passed in
otherwise it copies the passed in list and sorts the copy.

Add(), Remove(), Copy(), Cut(), Find()
All these procs behave identically to their list counterparts see the BYOND
reference for them

Fix()
Resorts the list.  Use this if something messes up the order of the list items
and it needs to be fixed.

RemoveAll(item1, item2, ...)
args - The item(s) which will be removed.

This proc works like remove except that it'll remove all instances of an item
from the list if there are several copies rather than just one.

RemoveDuplicates(item1, item2, ...)
args - The item(s) to remove duplicates for

This proc works like RemoveAll() however it leaves one of the items and only
clears out duplicates.

*/

RefSortedList
	var
		contents[]
	New(l[])
		if(istype(l,/list))
			contents = l.Copy()
			QuickSort(contents,/proc/_RefCompare)
		else if(l)
			contents = args
			QuickSort(contents,/proc/_RefCompare)
		else
			contents = new()
	proc
		Fix()
			QuickSort(contents,/proc/_RefCompare)
		Add()
			if(_containsList(args))
				_add(_unwrap(args))
			else
				_add(args)
		AddExact()
			_add(args)
		_add(l[])
			var/ind = 1
			QuickSort(l,/proc/_RefCompare)
			for(var/i in l)
				ind = _findInd(i, ind)
				if(ind > contents.len)
					contents.Add(i)
				else
					contents.Insert(ind,i)
					ind++

		Copy(start = 1, end = 0)
			return contents.Copy(start,end)
		Cut(start = 1, end = 0)
			contents.Cut(start,end)
		Find(elem, start = 1, end = contents.len + 1)
			var/ind = _findInd(elem,start,end)
			if(ind <= contents.len && contents[ind] == elem)
				return ind
			return 0;
		Remove()
			if(_containsList(args))
				_remove(_unwrap(args))
			else
				_remove(args)
		RemoveExact()
			_remove(args)
		_remove(l[])
			var/ind = 1
			QuickSort(l,/proc/_RefCompare)
			for(var/i in l)
				var/t = Find(i,ind)
				if(!t) continue
				ind = t
				if(ind)
					contents.Cut(ind, ind + 1)
					ind--
		RemoveAll()
			if(_containsList(args))
				_removeAll(_unwrap(args))
			else
				_removeAll(args)
		RemoveAllExact()
			_removeAll(args)
		_removeAll(l[])
			var/ind = 1
			QuickSort(l,/proc/_RefCompare)
			var/prev
			for(var/i in l)
				if(i == prev) continue
				var/t = Find(i,ind)
				if(!t) continue;
				ind = t;
				t = ind + 1;
				while(t <= contents.len && contents[ind] == contents[t])
					t++
				contents.Cut(ind,t)
				prev = i;
		RemoveDuplicates()
			if(_containsList(args))
				_removeDuplicates(_unwrap(args))
			else
				_removeDuplicates(args)
		RemoveDuplicatesExact()
			_removeDuplicates(args)

		_removeDuplicates(l[])
			if(l.len)
				var/ind = 1
				QuickSort(l,/proc/_RefCompare)
				var/prev
				for(var/i in l)
					if(i == prev) continue
					var/t = Find(i,ind)
					if(!t) continue;
					ind = t;
					t = ind + 1;
					while(t <= contents.len && contents[ind] == contents[t])
						t++
					if(ind + 1 < t)
						contents.Cut(ind + 1,t)
					prev = i
			else
				for(var/i = 1; i<= contents.len; i++)
					var/j = i + 1
					while(j <= contents.len && contents[i] == contents[j])
						j++
					if(i + 1 < j)
						contents.Cut(i+1,j)


		_unwrap(v[])
			var/l[] = v.Copy()
			for(var/i = 1; i <= l.len; i++)
				if(istype(l[i], /list) || istype(l[i], /RefSortedList))
					var/t[]
					if(istype(l[i],/RefSortedList))
						var/RefSortedList/r = l[i]
						t = r.contents
					else
						t = l[i]
					l.Cut(i,i+1)
					l.Add(t)
					i--
			return l

		_containsList(l[])
			for(var/i = 1; i <= l.len; i++)
				if(istype(l[i], /list) || istype(l[i], /RefSortedList))
					return 1
			return 0


		_findInd(elem, low = 1, high = contents.len + 1)
			var/mid
			while(low < high)
				mid = (low + high)>>1
				if(_RefCompare(contents[mid],elem) < 0)
					low = mid + 1
				else
					high = mid
			return low

proc
	_RefCompare(a,b)
		var/ra = "\ref[a]"
		var/rb = "\ref[b]"
		if(ra < rb)
			return -1
		else if(rb > ra)
			return 1
		else
			return 0