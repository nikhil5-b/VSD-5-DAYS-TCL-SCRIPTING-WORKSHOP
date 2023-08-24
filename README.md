**TCL Workshop: From Introduction to Advanced Scripting for Design and Synthesis**

**Author Name: Nikhil Bahadure**

**Acknowledgements: TCL Workshop by Mr. Kunal Ghosh , VLSI System Design**

**What is tcl?**
TCL, which stands for Tool Command Language, is a versatile and dynamic scripting language. With its clear and concise syntax, TCL is widely used in various domains, including software development, network administration, and embedded systems. It offers a rich set of built-in commands and supports seamless integration with C/C++ code. TCL's flexibility and ease of use make it an excellent choice for both beginners and experienced programmers seeking efficient and powerful scripting capabilities.

**Obejctive :**
Create a unique User Interface(UI) that takes RTL netlist & SDC constraints as inputs, and generate synthesized netlsit and Pre-layout timing report as an output. It should use Yosys Open source tool for synthesis and Opentimer to generate pre-layout timing reports

**Steps to follow to achieve the objective :**

Create a command and pass .csv file from UNIX shell to tcl script



**Day 1**
Creating a TCL Script and passing .csv file from UNIX shell as an argument to the TCL script

Using VSDSYNTH tool box, create a shell command and pass .csv from UNIX shell to Tcl script(vsdsynth.tcl)

Create a tcsh shell excutable file vsdsynth.tcl, create logo "VSD" and give it excute permission.

#!/bin/tcsh -f

chmod -R 777 laksh 

Note : Make sure the file is executable by using the above command

Scenario 1: User doesn't provide an input CSV file


![Screenshot 2023-08-24 183433](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/a3f44c5a-18e3-440d-a25d-d68f2a732d63)
