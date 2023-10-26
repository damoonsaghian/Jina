/*
arrays are implemented in a way that expanding them, and mutating them at the middle, is efficient
there is a root array that keeps addresses of segments (except the first segment)
	this array has a fixed size and is stored in stack
	the last element (if present) points to an array stored on heap, for furthur expantion
segments have equal sizes
the first segment is stored on stack (so small arrays do not need memory allocation)
the remaining segments are stored on heap
the destructor method frees the heap portion

dictionaries
https://en.wikipedia.org/wiki/Radix_tree
https://csatlas.com/c-radix-tree-nginx/
http://bxr.su/FreeBSD/sys/net/radix.h
https://github.com/antirez/rax
*/