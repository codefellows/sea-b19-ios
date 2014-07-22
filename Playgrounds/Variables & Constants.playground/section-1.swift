// Playground - noun: a place where people can play

import Cocoa

// Let's define a basic Swift class.
class Fruit {
    var type = 1
    var name = "Apple"
    var delicious = true
    var color = NSColor.redColor()
}

// We can get at some info about an instance of an object using reflect(), which returns a Mirror.
reflect(Fruit()).count
reflect(Fruit())[1].0
reflect(Fruit())[1].1.summary

// Dump a bunch of info about the object using reflection.
dump(Fruit())

// Let's make an instance and print all its properties to the console.
var theFruit=Fruit()

for var index=0; index<reflect(theFruit).count; ++index {
    println(reflect(theFruit)[index].0 + ": "+reflect(theFruit)[index].1.summary)
}