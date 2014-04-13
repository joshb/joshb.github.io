#!/usr/bin/perl -w

# Copyright (C) 2009 Josh A. Beam <josh@joshbeam.com>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# mbox2eml.pl (last modified July 14, 2009)
# This Perl script creates separate .eml files for each email message in
# a given mbox file. The .eml files are created in the directory that the
# script is run from and each file is named according to the position of
# the message in the mbox file (for example, "1.eml" for the first message).

use strict;

# make sure an mbox filename was given
if($#ARGV != 0) {
	print STDERR "Usage: $0 <mbox filename>\n";
	exit(1);
}

# open mbox file
open MBOX, $ARGV[0] or die "Unable to open mbox file\n";

# loop through each line from mbox file
my $fileCount = 0;
my $blankLineCount = 2;
while(my $line = <MBOX>)
{
	chomp($line);
	$line =~ s/\r//g;

	# check for the start of a new message
	if($blankLineCount >= 1 && $line =~ /^From /) {
		# open new eml file
		close EML;
		open EML, ">" . ++$fileCount . ".eml";

		print "Saving " . $fileCount . ".eml\r";
	} else {
		# write line to file
		print EML $line . "\n";
	}

	# check for blank lines
	if($line eq "") {
		++$blankLineCount;
	} else {
		$blankLineCount = 0;
	}
}

# close files
close EML;
close MBOX;

print "Saved " . $fileCount . " files\n";
