# The PDL-Playground

Thi application is merely a simple graphical shell to PDL. A work in progress, this tool has placeholders
for future expansion, and the eventual functionality is not yet fuly defined. 

### Objectives

A tool to explore PDL structures

![PDL Playground](https://github.com/saiftynet/PDL-Playground/assets/34284663/b30d057a-e0cb-40b3-9342-316644c14965)

### What it might do

* Create, manipulate and view ndarrays
* Create scripts that can process these data structures
* Integrated help to learn PDL
* Data analysis and transformations
* Once a workflow has been created, this workflow may be applied to multiple data sources
* With a series of domain specific scripts, one can then create custom applications with quick access to PDL processing.

### How it works

This tool uses [GUIDeFATE](https://github.com/saiftynet/GUIDeFATE), and the auto-generates most of the UI specific callbacks.  GUIDeFATE itself has limitted capabilities, but has been used to just get something going quickly, portably across many potential test platforms. A windows specific version will be available at [JustWin32](https://github.com/saiftynet/JustWin32).

The user can execute commands a line at a time.  The lines are copied into a "History" buffer.
They are also parsed and executed. The application has an internal hashref ($ndArrays) to stored user created
data structures.  Variables are created e.g. by:

`$x=sin(rvals(200,200)+1)`

The variable name $x is extracted and replaced with $ndArrays{x};

`parseInput()` parses the inputs identifying whether the user wants to create a ndarray, perform an operation,
output the data, produce a chart etc. 

### Proposed UI

![image](https://github.com/saiftynet/PDL-Playground/assets/34284663/6fff4fbe-6df1-4908-87fb-a70b49abd227)


Commands are entered in the "input" (8) box. They are processed and copied into the "history" box (10), allowing you the build up a list of instructions passed for future modification, and conversion to scripts.  the results of any outputs (e.g. print statements) are displayed in the multi-purpose output box (11).

The Multipurpose OutPut box is also where help messages and example scripts may appear. 

Help (6) activates the Help Option and displays a help window; either a genric help message, or if there is content in the Input box (8) and context sensitive help is provided. A similar scenrio is presented if the Examples (7) button is clicked.

Gnuplot outputs appear in a Gnuplot window, when invoked with commands like `imag` and `points`, `line` etc.
