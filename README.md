**TCL Workshop: From Introduction to Advanced Scripting for Design and Synthesis**

**Author Name: Nikhil Bahadure**                        

**Mail: 5nikhilbahadure@gmail.com**

**Acknowledgements: TCL Workshop by Mr. Kunal Ghosh , VLSI System Design**

**What is tcl:**
TCL, which stands for Tool Command Language, is a versatile and dynamic scripting language. With its clear and concise syntax, TCL is widely used in various domains, including software development, network administration, and embedded systems. It offers a rich set of built-in commands and supports seamless integration with C/C++ code. TCL's flexibility and ease of use make it an excellent choice for both beginners and experienced programmers seeking efficient and powerful scripting capabilities.

**Obejctive :**
Create a unique User Interface(UI) that takes RTL netlist & SDC constraints as inputs, and generate synthesized netlsit and Pre-layout timing report as an output. It should use Yosys Open source tool for synthesis and Opentimer to generate pre-layout timing reports

**Steps to follow to achieve the objective :**

Create a command and pass .csv file from UNIX shell to tcl script



**Day 1**

Creating a TCL Script and passing .csv file from UNIX shell as an argument to the TCL script

Using VSDSYNTH tool box, create a shell command and pass .csv from UNIX shell to Tcl script(vsdsynth.tcl)

Create a tcsh shell excutable file vsdsynth.tcl by using shebang, create logo "VSD" by using echo and give the tcl script executable permission by using chmod on the terminal.

#!/bin/tcsh -f

chmod -R 777 laksh 

Note : Make sure the file is executable by using the above command

**Case 1: User doesn't give any argument to the TCL script.** 


![Screenshot 2023-08-24 183433](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/a3f44c5a-18e3-440d-a25d-d68f2a732d63)



**Case 2: User gives .csv file as an argument but a wrong one or the path to .csv file is incorrect.**
![Screenshot 2023-08-24 185411](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/f0d003f4-e82c-4507-8e1a-926753f4b4b2)



**Case 3 : User typing "-help" or In such cases the user can exercise the -help option for this particular script to know the steps involved in correct execution of the script.**

![Screenshot 2023-08-24 185627](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/cf8cc532-e264-4bba-ac77-01747b318060)


Source the UNIX shell to TCL script by passing the required .csv file:

tclsh vsdsyntha.tcl $argv[1]


