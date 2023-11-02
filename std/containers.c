/*
arrays are implemented in a way that expanding them, and mutating them in the middle, is efficient
storage of an array is devided into equal size segments
the first segment is stored on the stack (so small arrays do not need memory allocation)
there is a field that if is not NULL, contains the address of an array (on the heap),
	that keeps addresses and indexes of the following segments (also on the heap)
the destructor method frees the heap portion of the array (if there is any)

dictionaries
https://en.wikipedia.org/wiki/Radix_tree
https://csatlas.com/c-radix-tree-nginx/
http://bxr.su/FreeBSD/sys/net/radix.h
https://github.com/antirez/rax
*/