
# TCL Workshop: From Introduction to Advanced Scripting for Design and Synthesis

**Author Name: Nikhil Bahadure**                        

**Mail: 5nikhilbahadure@gmail.com**

**Acknowledgements: TCL Workshop by Mr. Kunal Ghosh , VLSI System Design**


## **Objective :**

Create a unique User Interface(UI) that takes RTL netlist & SDC constraints as inputs, and generate synthesized netlsit and Pre-layout timing report as an output. It should use Yosys Open source tool for synthesis and Opentimer to generate pre-layout timing reports

## **What is TCL:**
TCL, which stands for Tool Command Language, is a versatile and dynamic scripting language. With its clear and concise syntax, TCL is widely used in various domains, including software development, network administration, and embedded systems. It offers a rich set of built-in commands and supports seamless integration with C/C++ code. TCL's flexibility and ease of use make it an excellent choice for both beginners and experienced programmers seeking efficient and powerful scripting capabilities.

## **Steps to follow to achieve the objective :**

It was achieved as below:

Day-1 : Creating a TCL command and pass .csv file from UNIX shell to tcl script

Day-2 : Variable Creation and Processing Constraints from CSV

Day-3 : Processing Clock and Input Constraints

Day-4 : Complete Scripting and Yosys Synthesis

Day-5 : Advanced Scripting Techniques and Quality of Results Generation

                                                              

## <ins>**Day 1**<ins>

<br>

Creating a TCL Script and passing .csv file from UNIX shell as an argument to the TCL script

Using VSDSYNTH tool box, create a shell command and pass .csv from UNIX shell to Tcl script(vsdsynth.tcl)

Create a tcsh shell excutable file vsdsynth.tcl by using shebang, create logo "VSD" by using echo and give the tcl script executable permission by using chmod on the terminal.

#!/bin/tcsh -f

chmod -R 777 vsdsynth.tcl

Note : Make sure the file is executable by using the above command

## Code Usage/Examples

```javascript
if ($#argv != 1) then
	echo "Info: please provide the csv file"
	exit 1
endif

if (! -f $argv[1] || $argv[1] == "-help" ) then
   if($argv[1] != "-help") then
   	echo "Error: Cannot find csv file $argv[1]. Exiting...."
	exit 1
   else
   	echo USAGE: ./vsdsynth \<csv file\>
	echo
	echo         where \<csv file\> consists of 2 columns, below keyword being in 1st column and  is case Sensitive.Please request VSD team for sample csv file

	echo
	echo         \<Design name\> is the name of top level module
	echo
	echo         \<output Directory\> is the name of output directory where you want to dump synthesis script,synthesized netlist and timing reports
	echo
	echo         \<Netlist Directory\> is the name of directory where all RTL netlist are present
	echo
	echo         \<Early Library Path\> is the file path of the early cell library to be used for STA
	echo
	echo         \<Late Library Path\> is the path of the late cell library to be used for Sta
	echo
	echo         \<Constarints file\> is csv file path of constraints to be used for STA
	echo
	echo
	exit 1
	endif
else
	tclsh vsdsynth.tcl $argv[1]
endif
```

**Case 1: User doesn't give any argument to the TCL script.** 


![Screenshot 2023-08-28 221828](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/dffd4399-cb6d-4e3a-94c4-afeaf265ad9e)
![Screenshot 2023-08-28 223002](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/1028b49e-5d8e-4a6f-ad4d-b9afa99b4333)




**Case 2: User gives .csv file as an argument but a wrong one or the path to .csv file is incorrect.**

![Screenshot 2023-08-28 223334](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/2371a620-0f8a-4fb0-8b0e-5191f8b7153e)



**Case 3 : User typing "-help" or In such cases the user can exercise the -help option for this particular script to know the steps involved in correct execution of the script.**

![Screenshot 2023-08-24 185627](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/cf8cc532-e264-4bba-ac77-01747b318060)


![Screenshot 2023-08-28 223622](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/d14fcc6c-abe1-436d-9ece-89b4491879f1)

Source the UNIX shell to TCL script by passing the required .csv file:

tclsh vsdsynth.tcl $argv[1]




## <ins>**Day 2**<ins>


<br>

Extracting Data from openMSP430_design_details.csv File
## Code Usage/Examples

```javascript
set filename [lindex $argv 0]
puts "initialize the package for csv  (comma seperated by value) and creation of matrix "
package require csv
package require struct::matrix
puts "package include now create the instance of matrix"
struct::matrix m
puts "assign file with the filename"
set f [open $filename]
puts "create automatic array of matrix with file as input"
csv::read2matrix $f m , auto 
close $f
puts "initialize columns"
set columns [m columns]
#m add columns $columns if auto not been used in the above#
m link my_arr
puts "initialize rows"
set num_of_rows [m rows]
set i 0



puts "initialize all variable with the all values one by one using while loop"

while {$i < $num_of_rows} {
	puts "\nInfo: Setting $my_arr(0,$i) as '$my_arr(1,$i)'"
	if {$i == 0} {
		set [string map {" " ""} $my_arr(0,$i)] $my_arr(1,$i)
	} else {
		set [string map {" " ""} $my_arr(0,$i)] [file normalize $my_arr(1,$i)]
	}
		set i [expr {$i+1}]
}



puts "\n"
puts "Initilization completed loop has been ended"
puts "\n Info: Below are the list of initial variables and their values.user can use these variables for further debug "
puts "\n"
puts "DesignName = $DesignName"
puts "OutputDirectory = $OutputDirectory"
puts "NetlistDirectory = $NetlistDirectory"
puts "EarlyLibraryPath = $EarlyLibraryPath"
puts "LateLibraryPath = $LateLibraryPath"
puts "ConstraintsFile = $ConstraintsFile"
```

Here is how the openMSP430_design_details.csv file looks like:

![Screenshot 2023-08-26 190837](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/6e304235-9fb5-416e-9a03-88a03ae3fb9d)


To operate on this data contained in the openMSP43_design_details.csv file, we need to create variables/pointers in our TCL script that can point to the information contained in openMSP43_design_details.csv file. A good way is to use a 2-D array datatype in the TCL script for mapping data contained in openMSP430_design_details.csv file.


![Screenshot 2023-08-26 032725](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/383af8da-fe72-4f16-af6c-6c8413ae82c9)



Check the existence of directories/files in the obtained path post normalizing

![Screenshot 2023-08-26 035911](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/3a001da5-d265-4441-9700-e36b3d148f31)


## <ins>**Day 3**<ins>


Tasks of the Day :

• Read the Clock, Input & Output Constraints from the file and create Synopsys Design Constraints (SDC) Format .sdc file

• Take care of the bus port to create SDC file

• Verify the generated .sdc file


Opening the openMSP43_design_constraints.csv file in libreoffice which we are going to convert to sdc file.We have to categorize all ports as inputs,ouputs,clocks and process them sepeartely.



![Screenshot 2023-08-26 194129](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/f43fa028-5abb-4204-b600-749040711407)




## Running Tests

CLOCKS

Clock latency and transition constraints

To get all the parameters under "CLOCKS" we need row and column number and traverse using them. from prev code , we know that row number for clocks = $clock_start and column number is $clock_start_column TO access them :


## Clock Code

```javascript
set clock_early_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start $col2 [expr {$input_start-1}] early_rise_delay] 0] 0]
set clock_early_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start $col2 [expr {$input_start-1}] early_fall_delay] 0] 0]
set clock_late_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start $col2 [expr {$input_start-1}] late_rise_delay] 0] 0]
set clock_late_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start $col2 [expr {$input_start-1}] late_fall_delay] 0] 0]
set clock_early_rise_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start $col2 [expr {$input_start-1}] early_rise_slew] 0] 0]
set clock_early_fall_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start $col2 [expr {$input_start-1}] early_fall_slew] 0] 0]
set clock_late_rise_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start $col2 [expr {$input_start-1}] late_rise_slew] 0] 0]
set clock_late_fall_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start $col2 [expr {$input_start-1}] late_fall_slew] 0] 0]
set clock_period [lindex [lindex [constraints search rect $clock_start_column $clock_start $col2 [expr {$input_start-1}] frequency] 0] 0]
set clock_duty_cycle [lindex [lindex [constraints search rect $clock_start_column $clock_start $col2 [expr {$input_start-1}] duty_cycle] 0] 0]
```


## Screenshots

**INPUT :**

![Screenshot 2023-08-28 201307](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/0a4f636e-6b6a-49bf-a438-0e0ff1cfa765)


![Screenshot 2023-08-28 195828](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/d8cd2c9c-a80a-4341-9434-c64dd2ec0042)

**OUTPUT :**

![Screenshot 2023-08-27 033201](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/0d1f8939-2486-4ec0-8e44-b57cad2cb446)


Now update the values under these colums for each row into SDC file


## Usage/Examples

```javascript
set sdc_file [open $OutputDirectory/$DesignName.sdc "w" ]
set i [expr {$clock_start+1}]
set end_of_ports [expr {$input_ports_start-1}]
puts "\n Info -SDC : Working on clock constraints....."
while { $i < $end_of_ports } {
	puts -nonewline $sdc_file "\n create_clock -name [constraints get cell 0 $i] -period [constraints get cell 1 $i] -waveform \{0 [expr {[constraints get cell 1 $i] * [constraints get cell 2 $i]/100}]\} \[get_ports [constraints get cell 0 $i]\]"

	puts -nonewline $sdc_file "\n set_clock_transition -rise -min [ constraints get cell $clock_early_rise_slew_start $i] \[get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\n set_clock_transition -fall -min [ constraints get cell $clock_early_fall_slew_start $i] \[get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\n set_clock_transition -rise -max [ constraints get cell $clock_late_rise_slew_start $i] \[get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\n set_clock_transition -fall -max [ constraints get cell $clock_late_fall_slew_start $i] \[get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\n set_clock_latency -source -early -rise [constraints get cell $clock_early_rise_delay_start $i] \[get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\n set_clock_latency -source -early -fall [constraints get cell $clock_early_fall_delay_start $i] \[get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\n set_clock_latency -source -late -rise [constraints get cell $clock_late_rise_delay_start $i] \[get_clocks [constraints get cell 0 $i]\]"
	puts -nonewline $sdc_file "\n set_clock_latency -source -late -fall [constraints get cell $clock_late_fall_delay_start $i] \[get_clocks [constraints get cell 0 $i]\]"
	set i [expr {$i+1}]
	puts "\n complete $i for end of port which is 3" 
}

```


## Screenshots


![Screenshot 2023-08-28 001803](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/d6079764-b475-4976-82b1-750e535c8544)


## 2.Inputs

To run tests, run the following command

Clock ports are standard ports but the ports under inputports are not standard ports as some are single bit and some are multi bit buses.SO

1)set variables for all the parameters
2)indicate if its a bus by appending a '*' in front of the port. we can do this by

i)get all the netlist files in a serial format set netlist [glob -dir $NetlistDirectory *.v] 

ii)open a temporary file under write mode set tmp_file [open /tmp/1 w] 

iii)now traverse for input ports through all the files and each line in the file until EOF and End of all files

iv)Since we get multiple declarations of the name_to_serach in inputs and outputs, we can split each finding using ';' as a delimiter use lindex[0] to get the first declaration

v)if there are multiple spaces,remove them and replace with single space as it makes a unique pattern and makes it easy to filter

vi)if number of that unique pattern count is < 2 - its a single bit wire else its a multibit bus

vii)Similar to clock ports ,send the input ports data to SDC file

## Usage/Examples Code

```javascript
#-----------------create input delay and slew constraints----------#
#------------------------------------------------------------------#


set input_early_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] early_rise_delay] 0 ] 0 ]
set input_early_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] early_fall_delay] 0 ] 0 ]
set input_late_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] late_rise_delay] 0 ] 0 ]
set input_late_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] late_fall_delay] 0 ] 0 ]



set input_early_rise_slew_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] early_rise_slew] 0 ] 0 ]
set input_early_fall_slew_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] early_fall_slew] 0 ] 0 ]
set input_late_rise_slew_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] late_rise_slew] 0 ] 0 ]
set input_late_fall_slew_start [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] late_fall_slew] 0 ] 0 ]



set related_clock [lindex [lindex [constraints search rect $clock_start_column $input_ports_start [expr {$number_of_columns-1}] [expr {$output_ports_start-1}] clocks] 0] 0]
set i [expr {$input_ports_start+1}]
set end_of_ports [expr {$output_ports_start-1}]
puts "\nInfo-SDC: Working on IO constarints......."
puts "\nInfo-SDC: Categorizing input ports as bits and bussed"

while { $i < $end_of_ports} {
#-----------------------optional script -----------differentiating input ports as bussed and bits----#

#--------------------------------------------------------------#
set netlist [glob -dir $NetlistDirectory *.v]
set tmp_file [open /tmp/1 w]
foreach f $netlist {
	set fd [open $f]
	puts "reading file $f"
	while {[gets $fd line] != -1} {
		set pattern1 " [constraints get cell 0 $i];"
		if {[regexp -all -- $pattern1 $line]} {
			puts "\npattern1 \"$pattern1\" found and matching line in verilog file \"$f\" is \"$line\""
			set pattern2 [lindex [split $line ";"] 0]
			puts "\ncreating pattern2 by splitting pattern1 using semi-colon as delimiter => \"$pattern2\""
			
			if {[regexp -all {input} [lindex [split $pattern2 "\S+"] 0]]} {
			puts "\nout of all patterns, \"$pattern2\" has matching string \"input\".So preserving this line and ignoring others"
				set s1 "[lindex [split $pattern2 "\S+"] 0] [lindex [split $pattern2 "\S+"] 1] [lindex [split $pattern2 "\S+"] 2]"
				puts "printing first 3 elements of pattern2 as \"$s1\" using space as delimiter"
				puts -nonewline $tmp_file "\n[regsub -all {\s+} $s1 " "]"
				puts "replace multiple spaces in s1 by single space and reformat as \"[regsub -all {\s+} $s1 " "]\""
			}
		}
	}
close $fd
}
close $tmp_file
set tmp_file [open /tmp/1 r]
#puts "reading [read $tmp_file]"
#puts "reading /tmp/1 file as [split [read $tmp_file] \n]"
#puts "sorting /tmp/1 content as [lsort -unique [split [read $tmp_file] \n ]]"
#puts "joining /tmp/1 as [join [lsort -unique [split [read $tmp_file] \n ]] \n]"
set tmp2_file [open /tmp/2 w]
puts -nonewline $tmp2_file "[join [lsort -unique [split [read $tmp_file] \n]] \n]"
close $tmp_file
close $tmp2_file
set tmp2_file [open /tmp/2 r]
#puts "count is [llength [read $tmp2_file]]"
set count [llength [read $tmp2_file]]
#puts "splitting content of tmp_2 using space and counting number of elements as $count"
if {$count > 2} {
	set inp_ports [concat [constraints get cell 0 $i]*]
	puts "bussed"
} else {
	set inp_ports [constraints get cell 0 $i]
	puts "not bussed"
}
	puts "input port name is $inp_ports since count is $count\n"
	puts -nonewline $sdc_file "\n set_input_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -rise -source_latency_included [constraints get cell $input_early_rise_delay_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\n set_input_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -fall -source_latency_included [constraints get cell $input_early_fall_delay_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\n set_input_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -rise -source_latency_included [constraints get cell $input_late_rise_delay_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\n set_input_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -fall -source_latency_included [constraints get cell $input_late_fall_delay_start $i] \[get_ports $inp_ports\]"


	puts -nonewline $sdc_file "\n set_input_transition -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -rise -source_latency_included [constraints get cell $input_early_rise_slew_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\n set_input_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -fall -source_latency_included [constraints get cell $input_early_fall_slew_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\n set_input_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -rise -source_latency_included [constraints get cell $input_late_rise_slew_start $i] \[get_ports $inp_ports\]"
	puts -nonewline $sdc_file "\n set_input_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -fall -source_latency_included [constraints get cell $input_late_fall_slew_start $i] \[get_ports $inp_ports\]"

	set i [expr {$i+1}]
}
close $tmp2_file
```


## Screenshots


![Screenshot 2023-08-28 051110](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/32c7267e-ef0e-499e-a0fa-d98908809109)


![Screenshot 2023-08-28 053657](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/b070bb73-ee6a-4440-8570-db26317feeab)

![Screenshot 2023-08-28 062709](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/82d40860-48cd-4a87-9417-227d4f01167a)

![Screenshot 2023-08-28 063822](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/201278a7-f2e0-4405-a712-9576c82c83cf)

![Screenshot 2023-08-28 063852](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/1b85ecfc-0709-4a9f-9cab-d6671ca9edc8)


3.SDC Contents W.R.T output ports

![Screenshot 2023-08-28 085032](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/d17ce078-9a09-40ae-8ad6-e4c5d0cbefca)



## <ins>**Day 4**<ins>

## YOSYS (Yosys Open SYnthesis Suite)
YOSYS is an open-source RTL synthesis and formal verification framework for digital circuits. It takes RTL descriptions (e.g., Verilog) as input and performs synthesis to generate a gate-level netlist. YOSYS supports technology mapping, optimization, and formal verification. It has a scripting interface, integrates with other EDA tools, and is widely used in academia and industry for digital design tasks.

## Tasks:

  1) **Checking the Hierarchy**

  2) **Error handling**


## Usage/Examples

```javascript
#------------------------------------------------------------------------------------------#
#----------------------------------------------Hireachy check------------------------------#
#------------------------------------------------------------------------------------------#

puts "\n Info: Creating hierachy check script to be used by Yosys"
set data "read_liberty -lib -ignore_miss_dir -setattr blackbox ${LateLibraryPath}"
set filename "$DesignName.hier.ys"
puts "filename is \"$filename\""
set fileId [open $OutputDirectory/$filename "w"]
puts "open \"$OutputDirectory/$filename\" write mode"
puts -nonewline $fileId $data

set netlist [glob -dir $NetlistDirectory *.v]
puts "Netlist is \"$netlist\""
foreach f $netlist {
	set data $f
	puts "data is \"$f\""
	puts -nonewline $fileId "\nread_verilog $f"
}
puts -nonewline $fileId "\nhierarchy -check"
close $fileId

puts "\nchecking hierarchy...."
set my_err [catch { exec yosys -s $OutputDirectory/$DesignName.hier.ys >& $OutputDirectory/$DesignName.hierarchy_check.log} msg]
puts "err flag is $my_err"
```

## Screenshots

![hirarachy](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/8b76d2b3-d77b-47b6-b6b1-04d7f7dd0f43)


![Screenshot 2023-08-28 184257](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/8ec7ebb8-c501-414a-a326-5a817ba75103)


![Screenshot 2023-08-28 180511](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/aefb0c4e-3eec-48ba-87b1-cdf7aa449510)


## Usage/Examples

```javascript
if { $my_err } {
	set filename "$OutputDirectory/$DesignName.hierarchy_check.log"
	puts "LOg file name in $filename" 
	set pattern {referenced in model}
	puts "pattern in $pattern"
	set count 0
	set fid [open $filename r]
	while {[gets $fid line] != -1} {
		incr count [regexp -all -- $pattern $line]
		if {[regexp -all -- $pattern $line]} {
			puts "\nError: module [lindex $line 2] is not part of design $DesignName.Please correct RTL in the path '$NetlistDirectory'"
			puts "\nInfo:Hierarchy check FAIL"
		}
	}
	close $fid
} else {
	puts "\nINfo: Hierarchy check PASS"
}
puts "\nINfo: Please find the hierarchy check details in [file normalize $OutputDirectory/$DesignName.hierarchy_check.log] for more info"
cd $working_dir
```


## Screenshots

![hirarachy](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/8b76d2b3-d77b-47b6-b6b1-04d7f7dd0f43)


![Screenshot 2023-08-28 170140](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/7844da13-6bcb-4219-aff1-f48f9998551c)

## <ins>**Day 5**<ins>

• Create a constraint .timing file from the .sdc file which can be applied to OpenTimer tool

• Take care of all bits of the bus while creating the .timing file 

• Create a .conf file input script for the OpenTimer tool

• Quality of Results (QoR) Generation

![Screenshot 2023-08-29 230317](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/63d5be54-559e-4df3-9fb5-76d2fb37b6b8)

![Screenshot 2023-08-29 143929](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/3c3ccb30-081d-4beb-b3f0-61036af5b829)

![Screenshot 2023-08-29 215420](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/ef52a29f-24d5-4160-b590-61b3e74eea77)

![Screenshot 2023-08-29 135239](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/596133b0-a342-4795-a5fe-08afe32afc27)

![Screenshot 2023-08-29 220600](https://github.com/nikhil5-b/VSD-5-DAYS-TCL-SCRIPTING-WORKSHOP/assets/52079538/a63ac631-6e18-4b77-8225-14b5bfc332f7)

## Conclusion
Usage of basic TCL syntax, variables, control structures, and procedures has been understood.
Learned about various TCL commands and their functionalities. Explored and Learned commands for file handling, string manipulation, mathematical operations, and interacting with the system.
Learned Linux based Procs and its application in TCL Scripting.
Learned effective scripting techniques using TCL and discovered techniques for error handling and debugging.
