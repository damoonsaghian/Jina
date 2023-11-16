/*
arrays are implemented in a way that expanding them, and insert/remove in the middle, is efficient
the storage of an array is devided into equal sized segments
the first segment is stored on the stack (so small arrays do not need memory allocation)
there is a field that if is not NULL, contains the address of an array (on the heap),
	that keeps addresses and indexes of the following segments (also on the heap)
	index of a segment is the index of its first element in the whole array
the destructor method frees the heap portion of the array (if there is any)

https://github.com/amadvance/tommyds/
*/

struct Array {
	void *[] arr;
	Int_u len
};
typedef struct Array Array;

Array Array_new() {}

void *Array_get(Array self, Int_u index) {}

void Array_append(Array self__mut, void *element) {}

void Array_extend(Array self__mut, Iter__i iterator) {}

void Array_insert(Array self__mut, ) {}

void Array_remove(Array self, Int_u index) {}

void Array_clear(Array self__mut) {}
