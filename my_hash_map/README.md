MyHashMap

Today you will implement your very own HashMap. If this sounds tricky, don't worry – we've provided specs. Download the skeleton before you start.
Learning Goals

    Be able to describe the characteristics of a good hashing function
    Be able to explain how a linked list works and know how to traverse it
    Be able to explain how a hash map works
    Know how to implement an LRU cache using hash maps and linked lists

Phase 1: IntSet

A Set is a data type that can store unordered, unique items. Sets don't make any promises regarding insertion order, and they won't store duplicates. In exchange for those constraints, sets have remarkably fast retrieval time and can quickly look up the presence of values.

Many mathematicians claim that sets are the foundation of mathematics, so basically we're going to build all of mathematics today. No big deal.

A set is an abstract data type (ADT). An ADT can be thought of as a high-level description of a structure and an API (i.e., a specific set of methods). Examples of ADTs are things like sets, maps, or queues. But any given data type or API can be realized through many different implementations. Those implementations are known as data structures.

Different data structures can implement the same abstract data type, but some data structures are worse than others. We're going to show you the best implementations, or close to them. (In reality, there's usually no single best implementation of an ADT; there are always tradeoffs.)

Sound cool yet? Now let's go build a Set.
MaxIntSet

We'll start with the first stage. In this version of a set, we can only store integers that live in a predefined range. So I tell you the maximum integer I'll ever want to store, and you give me a set that can store it and any smaller non-negative number.

    Initialize your MaxIntSet with an integer called max to define the range of integers that we're keeping track of.
    Internal structure:
        An array called @store, of length max
        Each index in the @store will correspond to an item, and the value at that index will correspond to its presence (either true or false)
        e.g., the set { 0, 2, 3 } will be stored as: [true, false, true, true]
        The size of the array will remain constant!
        The MaxIntSet should raise an error if someone tries to insert, remove, or check inclusion of a number that is out of bounds.
    Methods:
        #insert
        #remove
        #include?

Once you've built this and it works, we'll move on to the next iteration.
IntSet

Now let's see if we can keep track of an arbitrary range of integers. Here's where it gets interesting. Create a brand new class for this one. We'll still initialize an array of a fixed length--say, 20. But now, instead of each element being true or false, they'll each be sub-arrays.

Imagine the set as consisting of 20 buckets (the sub-arrays). When we insert an integer into this set, we'll pick one of the 20 buckets where that integer will live. That can be done easily with the modulo operator: i = n % 20.

Using this mapping, which wraps around once every 20 integers, every integer will be deterministically assigned to a bucket. Using this concept, create your new and improved set.

    Initialize an array of size 20, with each containing item being an empty array.
    To look up a number in the set, modulo (%) the number by the set's length, and add it to the array at that index. If the integer is present in that bucket, that's how we know it's included in the set.
    You should fill out the #[] method to easily look up a bucket in the store - calling self[num] will be more DRY than @store[num % num_buckets] at every step of the way!
    Your new set should be able to keep track of an arbitrary range of integers, including negative integers. Test it out.

ResizingIntSet

The IntSet is okay for small sample sizes. But if the number of elements grows pretty big, our set's retrieval time depends more and more on an array scan, which is what we're trying to get away from. It's slow.

Scanning for an item in an array (when you don't know the index) takes O(n) time, because you potentially have to look at every item. So if we're having to do an array scan on one of the 20 buckets, that bucket will have on average 1/20th of the overall items. That gives us an overall time complexity proportional to 0.05n. When you strip out the 0.05 constant factor, that's still O(n). Meh.

Let's see if we can do better.

    Make a new class. This time, let's increase the number of buckets as the size of the set increases. The goal is to have store.length > N at all times.
    You may want to implement an inspect method to make debugging easier.
    What are the time complexities of the operations of your set implementation?

Phase 2: Hashing
Notes:

    Don't spend more than 20 minutes working on hashing functions. Great hashing functions are hard to write. Your goal is to write a good-enough hashing function and move forth to the fun stuff ahead! Call over a TA if needed.
    Avoid using byebug inside your hash methods. The functioning of byebug's internal code will cause this to break since it calls Array#hash.
    You may want to refer to the resource on XOR. Please read the intro and section about exclusive or (^ in Ruby). XOR is a great tool for hashing because it's fast, and it provides a good, nearly uniform output of bits.

A hash function is a sequence of mathematical operations that deterministically maps any arbitrary data into a pre-defined range of values. Anything that does that is a hash function. However, a good hash function satisfies the property of being uniform in how it distributes that data over its range of values.

To create a good hash function, we want to be able to hash absolutely anything. That includes integers, strings, arrays, and even other hashes.

Also, a hash function should be deterministic, meaning that it should always produce the same value given the same input. It's also essential that equivalent objects produce the same hash. So if we have two arrays, each equal to [1, 2, 3], we want them both to hash to the same value.

So let's construct a nice hashing function that'll do that for us. Be creative here!

Write hash functions for Array, String, and Hash. Build these up sequentially.

    Use Integer#hash as a base hashing function. The trick here will be to create a scheme to convert instances of each class to a Integer and then apply this hashing function. This can be used on Numerics such as the index of an array element.
        Don't try to overwrite Ruby's native Integer#hash; making a hash function for numbers is something that's outside the scope of this assignment.
    Ordering of elements is essential to hashing an Array or String. This means each element in an Array or String should be associated with its index during hashing. Ex. [1, 2, 3].hash == [3, 2, 1].hash # => false
    On the other hand, ordering is not to be considered with a Hash. Hashes are based on sets and have no fixed order. Ex. {a: 1, b: 2}.hash == {b: 2, a: 1}.hash # => true

Hints:

    Can you write String#hash in terms of Array#hash?
    When you get to hashing hashes: one trick to make a hash function order-agnostic is to turn the object into an array, stably sort the array, and then hash the array. This'll make it so every unordered version of that same object will hash to the same value.

More reading on hash functions.
Phase 3: HashSet

Now that we've got our hashing functions, we can store more than just integers. A proper hashing function also ensures that the elements that we store will be evenly distributed amongst our buckets, hopefully keeping our buckets to length <= 1. Our freshly cooked up hashing functions are awesome, but for the rest of this project we'll rely on the built-in Ruby hashing functions to minimize the clustering of elements that can occur with our hand-made functions. Let's go ahead and implement a HashSet!

This will be a simple improvement on ResizingIntSet. Just hash every item before performing any operation on it. This will return an integer, which you can modulo by the number of buckets. Implement the #[] method to dry up your code. With this simple construction, your set will be able to handle keys of any data type.

Not too different from what we had before - and we now have a much better set that works with any data type! Time to request a code review.

Now let's take it one step further.

Up until now, our hash set has only been able to insert and then check for inclusion. We couldn't create a map of values, as in key-value pairs. Let's change that and create a hash map. But first, we'll have to build a subordinate, underlying data structure.

Phase 4: Linked List

A linked list is a data structure that consists of a series of nodes. Each node holds a value and a pointer to the next node (or nil). Given a pointer to the first (or head) node, you can access any arbitrary node by traversing the nodes in order.

We will be implementing a special type of linked list called a "doubly linked list" - this means that each node should also hold a pointer to the previous node. Given a pointer to the last (or tail) node, we can traverse the list in reverse order.

Our LinkedLists will ultimately be used in lieu of arrays for our HashMap buckets. In order to make the HashMap work, each node in your linked list will need to store both a key and a value.

The Node class is provided for you. It's up to you to implement the LinkedList.
Making Heads and Tails of LinkedList

There are a few ways to implement LinkedList. You can either start with the head and tail of your list as nil, or start them off as sentinel nodes. For this project, we will be using sentinel nodes to avoid unnecessary type checking for nil.

A sentinel node is merely a "dummy" node that does not hold a value. Your LinkedList should keep track of pointers (read: instance variables) to sentinel nodes for its head and tail. The head and tail should never be reassigned.

Given these properties of our LinkedList, how might we check if our list is empty? How might we check if we are at the end of our list? Think about how your linked list will function as you implement the methods below.
Methods to Implement

Go forth and implement the following methods:

    first
    empty?
    #append(key, val) - Append a new node to the end of the list.
    #update(key, val) - Find an existing node by key and update its value.
    #get(key)
    #include?(key)
    #remove(key)

If you are surprised by any spec failures along the way, remember to read both the RSpec messages and the spec file itself. Does the setup for this test rely on any methods that you haven’t yet implemented? Be sure not to put on “spec blinders” - try out the methods you’re writing for yourself to test their behavior, and don’t let passed or failed specs be your only metric for whether you’ve written the code you need.

Once you're done with those methods, we're also going to make your linked lists enumerable. We want them to be just as flexible as arrays. Remember back to when you wrote Array#my_each, and let's get this thing enumerating. The block passed to #each will yield to a node.

Once you have #each defined, you can include the Enumerable module into your class. As long as you have each defined, the Enumerable module gives you map, each_with_index, select, any? and all of the other enumeration methods for free! (Note: you may wish to refactor your #update, #get, and #include methods to use your #each method for cleaner code!)

Phase 5: Hash Map (reprise)

So now let's incorporate our linked list into our hash buckets. Instead of Arrays, we'll use LinkedLists for our buckets. Each linked list will start out empty. But whenever we want to insert an item into that bucket, we'll just append it to the end of that linked list.

So here again is a summary of how you use our hash map:

    Hash the key, mod by the number of buckets (implement the #bucket method first for cleaner code - it should return the correct bucket for a hashed key)

    To set, insert a new node with the key and value into the correct bucket. (You can use your LinkedList#append method.) If the key already exists, you will need to update the existing node.
    To get, check whether the linked list contains the key you're looking up.
    To delete, remove the node corresponding to that key from the linked list.

Finally, let's make your hash map properly enumerable. You know the drill. Implement #each, and then include the Enumerable module. Your method should yield [key, value] pairs.

Also make sure your hash map resizes when the count exceeds the number of buckets! In order to resize properly, you have to double the size of the container for your buckets. Having done so, enumerate over each of your linked lists and re-insert their contents into your newly-resized hash map. If you don't re-hash them, your hash map will be completely broken. Can you see why?

Now pass those specs.

Once you're done, you should have a fully functioning hash map that can use numbers, strings, arrays, or hashes as keys. Show off your understanding by asking a TA for a Code Review.
Head to Part 2!

Once you are finished with phases 1 - 5 head over to Part Two. Accessing this on GitHub? Use this link.