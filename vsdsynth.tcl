#! /bin/env tclsh

#-------------------inside tcl file---------------------#

#------------------Begining of the file_________________#

puts "WELCOME :AN AUTOMATION CREATED BY NIKHIL BAHADURE FOR DESIGN SYNTHESIS UNDER THE GUIDENCE OF KUNAL GHOSH "
#-------------creation of the variable-----------------------#
#...
#.............DesignName OutputDirectory NetlistDirectory EarlyLibraryPath LatelibraryPath..........#


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

#--------------------Below script checks if directories and files mentioned in csv file, exits or not..........#




if {! [file exists $EarlyLibraryPath] } {
	puts "\nError: Cannot find early cell library in path $EarlyLibraryPath. Exiting......"
	exit
} else {
	puts "\nInfo: Early cell library found in path $EarlyLibraryPath"
}



if {! [file exists $LateLibraryPath] } {
	puts "\nError: Cannot find late cell library in path $LateLibraryPath. Exiting......"
	exit
} else {
	puts "\nInfo: Late cell library found in path $LateLibraryPath"
}



if {! [file isdirectory $OutputDirectory] } {
	puts "\nInfo: Cannot find output directory $OutputDirectory. Creating $OutputDirectory"
	file mkdir $OutputDirectory
} else {
	puts "\nInfo: Output Directory found in path $OutputDirectory"
}



if {! [file isdirectory $NetlistDirectory] } {
	puts "\nInfo: Cannot find RTL netlist directory in path $NetlistDirectory. Exiting....."
	exit
} else {
	puts "\nInfo: RTL netlist directory found in path $NetlistDirectory"
}


if {! [file exists $ConstraintsFile] } {
	puts "\nError: Cannot find constraint file in path $ConstraintsFile. Exiting......"
	exit
} else {
	puts "\nInfo:Constraint file found in path $ConstraintsFile"
}



#--------------------------------------------------------------------------------#
#---------------------------Constraint File Creation-----------------------------#
##-------------------------------SDC Format______________________________________#
#--------------------------------------------------------------------------------#


puts "\n Info : Dumping SDC contraints for $DesignName"
struct::matrix constraints
set chan [open $ConstraintsFile]
csv::read2matrix $chan constraints , auto
close $chan
set number_of_rows [constraints rows]
set number_of_columns [constraints columns]

puts "\n Constraint matrix parameters"
puts "\n row = $number_of_rows"
puts "\n columns = $number_of_columns"

#-----------------Check row number for "clocks" and column number for "IO delays and slew section "in constraints.csv--------------#

set clock_start [lindex [lindex [constraints search all CLOCKS] 0] 1]
set clock_start_column [lindex [lindex [constraints search all CLOCKS] 0] 0]

#--------------Checks row number for "inputs" section in constraints.csv-------------#
set input_ports_start [lindex [lindex [constraints search all INPUTS] 0] 1]


#--------------Checks row number for "outputs" section in constraints.csv-------------#
set output_ports_start [lindex [lindex [constraints search all OUTPUTS] 0] 1]

#puts "\n clock_start_rows = $clock_start"
#puts "\n clock_start_column = $clock_start_column"
#puts "\n input_port_start = $input_port_start"


#----------------------------clock constraints------------------------#
#---------------------------clock latency constraints-----------------#

set clock_early_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] early_rise_delay] 0] 0]
puts "\nclock_early_rise_delay_start = $clock_early_rise_delay_start"


set clock_early_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] early_fall_delay] 0] 0]
puts "\nclock_early_fall_delay_start = $clock_early_fall_delay_start"


set clock_late_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] late_rise_delay] 0] 0]
puts "\nclock_late_rise_delay_start= $clock_late_rise_delay_start"


set clock_late_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] late_fall_delay] 0] 0]
puts "\nclock_late_fall_delay_start = $clock_late_fall_delay_start"



#----------------------------clock transition contraints--------------------#


set clock_early_rise_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] early_rise_slew] 0] 0]


puts "\nclock_late_fall_slew = $clock_early_rise_slew_start"
set clock_early_fall_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] early_fall_slew] 0] 0]


puts "\nclock_late_fall_slew = $clock_early_fall_slew_start"
set clock_late_rise_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] late_rise_slew] 0] 0]


puts "\nclock_late_fall_slew = $clock_late_rise_slew_start"
set clock_late_fall_slew_start [lindex [lindex [constraints search rect $clock_start_column $clock_start [expr {$number_of_columns-1}] [expr {$input_ports_start-1}] late_fall_slew] 0] 0]

puts "\nclock_late_fall_slew = $clock_late_fall_slew_start"


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

#------------------------------------------------------------------#
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
			#--------------------------------------------#
			puts "\nInside while loop before if loop"
			#--------------------------------------------#

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







#------------------------------------------------------------------#
#-----------------Create Output delay and Load Constraints----------#
#------------------------------------------------------------------#


set output_early_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] early_rise_delay] 0 ] 0 ]

set output_early_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] early_fall_delay] 0 ] 0 ]

set output_late_rise_delay_start [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] late_rise_delay] 0 ] 0 ]

set output_late_fall_delay_start [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] late_fall_delay] 0 ] 0 ]

set output_load_start [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] load] 0 ] 0 ]

set related_clock [lindex [lindex [constraints search rect $clock_start_column $output_ports_start [expr {$number_of_columns-1}] [expr {$number_of_rows-1}] clocks] 0 ] 0 ]



set i [expr {$output_ports_start+1}]
set end_of_ports [expr {$number_of_rows}]
puts "\nInfo-SDC: Working on IO constarints......."
puts "\nInfo-SDC: Categorizing output ports as bits and bussed"

while { $i < $end_of_ports} {
#-----------------------optional script -----------differentiating output ports as bussed and bits----#

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
			#--------------------------------------------#
			puts "\nInside while loop before if loop"
			#--------------------------------------------#

			if {[regexp -all {output} [lindex [split $pattern2 "\S+"] 0]]} {
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
	set op_ports [concat [constraints get cell 0 $i]*]
	puts "bussed"
} else {
	set op_ports [constraints get cell 0 $i]
	puts "not bussed"
}

	puts "output port name is $op_ports since count is $count\n"

	puts -nonewline $sdc_file "\n set_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -rise -source_latency_included [constraints get cell $output_early_rise_delay_start $i] \[get_ports $op_ports\]"

	puts -nonewline $sdc_file "\n set_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -min -fall -source_latency_included [constraints get cell $output_early_fall_delay_start $i] \[get_ports $op_ports\]"

	puts -nonewline $sdc_file "\n set_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -rise -source_latency_included [constraints get cell $output_late_rise_delay_start $i] \[get_ports $op_ports\]"

	puts -nonewline $sdc_file "\n set_output_delay -clock \[get_clocks [constraints get cell $related_clock $i]\] -max -fall -source_latency_included [constraints get cell $output_late_fall_delay_start $i] \[get_ports $op_ports\]"
	
	puts -nonewline $sdc_file "\n set_load [constraints get cell $output_load_start $i] \[get_ports $op_ports\]"

	set i [expr {$i+1}]
}
close $tmp2_file
close $sdc_file

puts "\nInfo: SDC created.Please use constraints in path $OutputDirectory/$DesignName.sdc"

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
