#!/usr/bin/env perl 
#A test script that gives a graphical interface to PDL

use strict;
use warnings;
use lib "../lib/";
use GUIDeFATE;
use PDL;
use PDL::Graphics::Simple;
use File::Copy;

# Data output

my $window=<<END;
+---------------------------------------------------------+
|T  PDL Playground                                        |
+M--------------------------------------------------------+
|                     PDL Playground                      |
|{Clear }{Load  }{Save  }{Next  }{Run   }{Help  }{Example}|
|[                                               ]{Submit}|
|   History                      Output                   |
|+T---------------++T------------------------------------+|
||#script;        ||#PDL output                          ||
||                ||                                     ||
||                ||                                     ||
||                ||                                     ||
||                ||                                     ||
||                ||                                     ||
||                ||                                     ||
||                ||                                     ||
||                ||                                     ||
||                ||                                     ||
|+----------------++-------------------------------------+|
+---------------------------------------------------------+

Menu
-File
--New Script
--Open Script
--Save Script
--Quit
-Image
--Load Image
--Reload Image
--Save Image
--Open With... 
--Notes
--Batch Process
-Data
--Load Data
--Reload Data
--Save Data
--Notes
END


#setup PDL data store
my $ndArrays={};
my $script;
my $stack=[];
my %help=(
   Help=><<EOH,
# Section:"Help", Category:"Help"
# Keywords: Help, UI, Help formatting 
#
#  The User Interface has the following elements 
# {Clear(1)}{Load(2)}{Save(3)}{Next(4)}{Run(5)}{Help(6)}{Example(7)}
# [ Entry Box (8)  ]  {Submit(9)}
# Script/History (10)  Multimodal interactivity box (11)
#
#
# To Start using this tool try Entering a command in the entry box (8) above
# The Command is executed and copied into the history window (10) 
# Typical commands may viewed by clicking the Example(7)  Button.
# To get Help on a specific topic, enter text above and then click the help(6) button
# To get this Message Back, click on Help{6} with an empty entry box
# You can add to the Help sections
# Edit this Box, Changing the Section, Category and Keywords, and the content
# This must be saved (3) for the help to persist.
EOH
  

);

my %examples=(
   Example=><<EOH,
# Section:"Example", in Category:"Example"
# Keywords: Help, UI, Help formatting 
#
# Examples
# Examples will have a description and a script that could be be cut and pasted
# into the Script/Input text box.  
#
# \$x2 = rvals (15,15)
# \$y  = sequence(50)
# \$x  = \$y*\$y - 15*\$y +16
# points \$x, \$y
# 
# You can edit and save this example to add more examples.  If you don't 2
EOH

);


my %views=(
    Output=>"",
    Input=>"",
    Stack =>"",
    Variables =>"",
    Subroutines=>"",
    Logs=>"",
    Errors=>"",
);
my $viewIndex=0;
my $viewList=[qw/Output Input Stack  Variables  Subroutines Errors/];
my $view=$viewList->[$viewIndex];

my $assist=$ARGV[1]?$ARGV[1]:"a";
my $gui=GUIDeFATE->new($window,"gtk",$assist);
my $frame=$gui->getFrame||$gui;

$frame->setValue("TextCtrl13",'');
$frame->setValue("TextCtrl15",'');

$gui->MainLoop;


sub parseInput{
	my ($inStr,$source)=@_;
   	$frame->appendValue("TextCtrl13","\n".$frame->getValue("textctrl9"));
    $inStr=trim($inStr);
    print $inStr,"\n";
    if ($inStr=~/^#/){
		# comment line...do nothing
	}
    elsif ($inStr=~/^\$([a-z][a-zA-Z0-9_]*)\s?=(.*)$/){
		$ndArrays->{$1}=evaluate($2);
		print "\n# Variable \$".$1." has been set to $ndArrays->{$1}\n";	 
	}
    elsif ($inStr=~/^print\s+\$([a-z][a-zA-Z0-9_]*)$/){	 
	    setView("append","Output","\n\$".$1. " is ".$ndArrays->{$1});
	}
    elsif ($inStr=~/^print\s+/){	 
		$inStr=~s/print\s?//;
	    setView("append","Output","\n$inStr   is ".evaluate($inStr));
	}
    elsif ($inStr=~/\$([a-z][a-zA-Z0-9_]*)/){
		evaluate($inStr);
		print $inStr,"\n";
	}
	else{
		my $outStr=eval($inStr);	 
		setView("append","Output","\n$outStr");	 
		
	}
    $frame->setValue("textctrl9","");
	
};

sub evaluate{
	my $in=shift;
	while  ($in=~/\$([a-z][a-zA-Z0-9_]*)/){
		$in=~s/\$([a-z][a-zA-Z0-9_]?)/#ndArrays->{$1}/;
	};
	$in=~s/#/\$/g;
	return eval "$in"
	
}

sub trim{
	my $in=shift;
	$in=~s/^\s+|\s+$//g;
	return $in;
}


# multipurpose load to load data, help file, scripts,examples
sub load{
	my ($dataType,$file,$params)=@_;
	if ($dataType eq "support"){
		
	}
}

# the multipurpose output box displays many outputs
# Help, Example search and and the variews views of the 
# user defined data/subroutines, the stack and out of operations

sub setView{
	my ($mode,$op,$content)=@_;
	if ($mode eq "clear"){
		$views{$op}="";
	}
	elsif ($mode eq "set"){
		$views{$op}=$content
	}
	elsif ($mode eq "append"){
		$views{$op}.=$content
	}
	showView($op);
}

sub showView{
	my $op=shift;
	if (exists $views{$op}){
		$frame->setLabel("stattext11",$op);
		$frame->setValue("TextCtrl15",$views{$op});
	}
	else{
		print "No output type $op found"
	}
}

sub help{  # obtained by trihggering "Help"
	my $subject=$frame->getValue("textctrl9")||"Help";
	$frame->setLabel("stattext11","Help");
	my $helpMessage="No Help Found for $subject";
    if (exists $help{$subject}){
		$helpMessage=$help{$subject}
	}
	else{
		 #searchHelp routine
	}
	$frame->setValue("TextCtrl15",$helpMessage)
	
}

sub example{  # obtained by trihggering "Help"
	my $subject=$frame->getValue("textctrl9")||"Example";
	$frame->setLabel("stattext11","Example");
	my $egText="No Example Found";
    if (exists $examples{$subject}){
		$egText=$examples{$subject}
	}
	else{
		 #searchExample routine
	}
	$frame->setValue("TextCtrl15",$egText)
	
}


#Static text 'PDL Playground'  with id stattext0
sub btn1 {#called using button with label Clear 
  # subroutione code goes here
    $frame->setValue("textctrl9","");
    $frame->setValue("TextCtrl13","");
    $frame->setValue("TextCtrl15","");
    
   };

sub btn2 {#called using button with label Load 
  # subroutione code goes here
   };

sub btn3 {#called using button with label Save 
  # subroutione code goes here
   };

sub btn4 {#called using button with label List 
  # subroutione code goes here
   };

sub btn5 {#called using button with label Run 
  # subroutione code goes here
   };

sub btn6 {#called using button with label Help 
  help();
   };

sub btn7 {#called using button with label Example 
  example();
   };

sub btn8 {#called using button with label Submit 
 parseInput( $frame->getValue("textctrl9"));
   };

sub textctrl9 {#called using Text Control with default text '                                                 '
  # subroutione code goes here
   };

#Static text 'History'  with id stattext10
#Static text 'Output'  with id stattext11
#SubPanel 'T' Id 13 found position  1 height 14 width 16 at row 5 with content #script; 
#SubPanel 'T' Id 15 found position  19 height 14 width 37 at row 5 with content #PDL output 
#Menu found
#Menuhead File found
#Menu New Script found, calls function &menu18 
sub menu18 {#called using Menu with label New Script
  # subroutione code goes here
   };

#Menu Open Script found, calls function &menu19 
sub menu19 {#called using Menu with label Open Script
  # subroutione code goes here
   };

#Menu Save Script found, calls function &menu20 
sub menu20 {#called using Menu with label Save Script
  # subroutione code goes here
   };

#Menu Quit found, calls function &menu21 
sub menu21 {#called using Menu with label Quit
  # subroutione code goes here
   };

#Menuhead Image found
#Menu Load Image found, calls function &menu24 
sub menu24 {#called using Menu with label Load Image
  # subroutione code goes here
   };

#Menu Reload Image found, calls function &menu25 
sub menu25 {#called using Menu with label Reload Image
  # subroutione code goes here
   };

#Menu Run Script found, calls function &menu26 
sub menu26 {#called using Menu with label Run Script
  # subroutione code goes here
   };

#Menu Save Image found, calls function &menu27 
sub menu27 {#called using Menu with label Save Image
  # subroutione code goes here
   };

#Menu Undo found, calls function &menu28 
sub menu28 {#called using Menu with label Undo
  # subroutione code goes here
   };

#Menu Batch Process found, calls function &menu29 
sub menu29 {#called using Menu with label Batch Process
  # subroutione code goes here
   };

#Menuhead Data found
#Menu Load Data found, calls function &menu32 
sub menu32 {#called using Menu with label Load Data
  # subroutione code goes here
   };

#Menu Reload Data found, calls function &menu33 
sub menu33 {#called using Menu with label Reload Data
  # subroutione code goes here
   };

#Menu Run Script found, calls function &menu34 
sub menu34 {#called using Menu with label Run Script
  # subroutione code goes here
   };

#Menu Save Data found, calls function &menu35 
sub menu35 {#called using Menu with label Save Data
  # subroutione code goes here
   };


