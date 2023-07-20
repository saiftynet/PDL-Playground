# The PDL-Playground

A simple GUI Interface to play with PDL.  A work in progress, this tool has placeholders
for future expansion, and the eventual functinailty is not yet fuly defined

### Objectives

A tool to explore PDL structures

![PDL Playground](https://github.com/saiftynet/PDL-Playground/assets/34284663/b30d057a-e0cb-40b3-9342-316644c14965)

### What it might do

* Create, manipulate and view ndarrays
* Create scripts that can process these data structures
* Integrated help to learn PDL
* Data analysis and transformations
* Create applications that can use PDL

### How it works

This tool uses GUIDeFATE, and the auto-generates most of the UI specific callbacks.

The user can execute commands a line at a time.  The lines are copied into a "History" buffer.
They are also parsed and executed. The application has an internal hashref ($ndArrays) to stored user created
data structures.  Variables are created e.g. by:

`$x=sin(rvals(200,200)+1)`

The variable name $x is extracted and replaced with $ndArrays{x};

`parseInput()` parses the inputs identifying whether the user wants to create a ndarray, perform an operation,
output the data, produce a chart etc.


