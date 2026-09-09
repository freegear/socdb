#!/usr/bin/perl 
#
# Upload an image into some StrongARM based system running the
# script image.
#
# David Rusling (David.Rusling@Digital.Com), December 1997
#

use strict;
use Getopt::Long;
use File::Path;
use POSIX qw(:termios_h);
use FileHandle;

use subs qw{doCommand, doFile, printVersion, printHelp, 
	    remoteCommand, fSize};
my $verbose ;
my $debug ;

# --------------------------------------------------------------------
# local routines
# --------------------------------------------------------------------
sub serialOpen {
#
# Open the serial device.
#
    my ($serialDevice) = @_;
# create a termios structure (destroyed on exit)
    my $termios;
    my $fd;

    if ($debug) {
	print "serialOpen($serialDevice) called\n" ;
    }

# Open the default serial port (/dev/cua0)
# (and get the file descriptor that was assigned)
    sysopen SERIALDEVICE, "$serialDevice", O_RDWR | O_NOCTTY 
	    or die "ERROR: Cannot open $serialDevice\n";
    $fd = fileno(SERIALDEVICE) ;

#
# Return the file descriptor
#
    if ($debug) {
	print "serialOpen(): returning $fd\n";
    }
    return $fd ;
}

sub serialSetTTY {
    my ($fd) = @_ ;
    my $termios ;
    my $c_iflag ;
    my $c_oflag ;
    my $c_lflag ;
    my $c_cflag ;

    if ($debug) {
	print "serialSetTTY($fd) called\n";
    }

# Create a new Termios object, this object will be destroyed 
# automatically when it is no longer needed.
    $termios = POSIX::Termios->new ;

# get its attributes
    $termios->getattr($fd) ;

# Set the device up (assume 8 data bits, no stop bits)
    $termios->setcc(&POSIX::VMIN, 32) ;             # Wake up after 32 chars
    $termios->setcc(&POSIX::VTIME, 1) ;             # Wake up 0.1 seconds after 1st char

    $c_iflag = $termios->getiflag; 
    $c_iflag = $c_iflag & ~(BRKINT | IGNPAR | PARMRK |
			    INPCK | ISTRIP | INLCR | 
			    IGNCR | ICRNL | IXON) ;
    $c_iflag = $c_iflag | (IGNBRK | IXOFF) ;
    $termios->setiflag($c_iflag) ;

    $c_oflag = $termios->getoflag ;
    $c_oflag &= ~(OPOST) ;
    $termios->setoflag($c_oflag) ;

    $c_lflag = $termios->getlflag ;
    $c_lflag &= ~(ECHO | ECHOE | ECHOK | ECHONL | ICANON |
		  ISIG | NOFLSH | TOSTOP) ;
    $termios->setlflag($c_lflag) ;

    $c_cflag = $termios->getcflag ;
    $c_cflag &= (CSIZE | CSTOPB | HUPCL | PARENB) ;
    $c_cflag |= CLOCAL | CREAD | CS8 ;
    $termios->setcflag($c_cflag) ;

# Now set up the device's speed.
    $termios->setospeed(&POSIX::B9600) ;
    $termios->setispeed(&POSIX::B9600) ;

# Flush it

# Turn it on
    $termios->setattr($fd, &POSIX::TCSANOW) ;
}

sub printVersion {
    print "\nUpload (SLOWLY) [1.0]\n\n" ;
}

sub printHelp {
#
# print some help
#
    printVersion() ;
    print "This tool uploads images (SLOWLY)\n\n" ;
    print "Command line options:\n" ;
    print " --help, -h                  : print help\n" ;
    print " --verbose, -v               : be verbose\n" ;
    print " --image, -i <imagefile>     : supply an image file\n" ;
    print " --base, -b <addr>           : write image to address\n" ;
    print " --port, -p <dev>            : The serial device to open\n";
    print "\n";
}

sub remoteCommand {
    my ($command) = @_ ;
    my $s ;

    syswrite(SERIALDEVICE, $command, length $command) ;
    syswrite(SERIALDEVICE, "\n", 1) ;
    while (1) {
	sysread(SERIALDEVICE, $s, 80) ;
	if (index($s,"OK") >= 0) {
	    return ;
	}
	if (index($s,"ERR") >= 0) {
	    return ;
	}
	if (index($s,"Not Supported") >= 0) {
	    return ;
	}
    }
}

sub doCommand {
    my ($command) = @_ ;
    my $where ;

# remove the final linefeed
    chop $command ;

# is it a script file: !<name of file>?
    $where = index $command, "!";
    if ($where == 0) {
	doFile(substr $command, 1) ;
	return ;
    }

# lower case the command (call me wierd)
    $command = lc $command;
    
# present the command to the remote end
    remoteCommand($command) ;
}

sub fSize {
    my ($fileName) = @_ ;

    return (stat $fileName)[7];
}

sub doFile {
    my ($filename) = @_ ;
    my $len ;
    my $i;
    my $s ;
    my $where ;
    my $command ;

# for now, fudge the length of the file and where it goes
    $len = fSize($filename) ;
    print "Image is $len bytes long\n";
    $where = 200000 ;

# open the image file and write it out to the raw port.
    open(IMAGEFILE, $filename) 
	or die "Can't open script file $filename: $!\n";
    for ($i = 0 ; $i < $len ; $i++) {
	sysread(IMAGEFILE, $s, 1);
	$s = unpack "C", $s;
	$s = sprintf "%2x", $s;
	doCommand("w8 $where $s\n");
	if (($i % 256) == 0) {
	    print "#\n";
	}
	$where++;
    }
    close IMAGEFILE;
}

# --------------------------------------------------------------------
# main body
# --------------------------------------------------------------------
#
# Parse the arguments:
#
# --help, -h          : print help
# --verbose, -v       : be verbose
# --script, -s <file> : execute this script file
#
my $help = 0;
my $imageFile = 0 ;
my $line;
my $serialDevice = "/dev/cua0";
my $fd;
my $address = 0x200000;
my $time;

$verbose = 0;
$debug = 0;

&GetOptions(
	    "help" => \$help, "h" => \$help,
	    "verbose" => \$verbose, "v" => \$verbose,
	    "image=s" => \$imageFile, "i=s" => \$imageFile,
	    "debug" => \$debug, "d" => \$debug,
	    "base=i" => \$address, "b=i" => \$address,
	    "port=s" => \$serialDevice, "p=s" => \$serialDevice
	    ) ;

# now go and do stuff depending on the arguments
if ($help) {
    printHelp() ;
    exit 0 ;
}

# check that an image filename was given
if ($imageFile) {
} else {
    print "ERROR: no image file given\n";
    exit 1;
}

# tell the world
printVersion() ;
print "Image file is $imageFile\n";
print "Loading at address $address\n";

#
# Open the serial device.
# 
$fd = serialOpen($serialDevice) ;

#
# Set it up
#
serialSetTTY($fd) ;

#
# Set echo off and CR on by default
#
doCommand("setecho 0\n") ;
doCommand("setcr 1\n") ;

# Load the image into memory 
$time = time ;
doFile("$imageFile");
$time = time - $time;
print "Upload took $time seconds\n";





