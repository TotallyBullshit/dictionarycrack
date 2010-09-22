#!/usr/bin/perl -w
# Created @ 12.03.2009 by TheFox@fox21.at
# Version: 1.0.0
# Copyright (c) 2009 TheFox

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Description:
# Crack MD5-hashes with a dictionary
# Download the dictionary files from
# http://pub.fox21.at/dictionary/


use strict;
use Digest::MD5 qw(md5 md5_hex md5_base64);

$| = 1;

my $SEARCH = shift @ARGV || '.txt';
my @HASHES = @ARGV;

#die "no hashes\n" unless @HASHES;
push @HASHES, '609e39a9fedb2af6c9aa0f0debe1e232' unless @HASHES;


my %cracked = ();
my @dictfiles = glob("./*$SEARCH*");
die "no dictionaries found with '*$SEARCH*'\n" unless @dictfiles;

for my $dictfile (@dictfiles){
	print "open  $dictfile\nsearching for hashes. please wait...\n";
	open DICT, "< $dictfile";
	while(my $row = <DICT>){
		$row =~ s/[\r\n]+$//sig;
		#print "row: >$row<\n";
		my $rowmd5 = md5_hex $row;
		my $c = 0;
		for my $hash (@HASHES){
			if($hash eq $rowmd5){
				print "found $hash = $row\n";
				splice @HASHES, $c, 1;
				$cracked{$hash} = $row;
			}
			else{
				$row = uc $row;
				$rowmd5 = md5_hex $row;
				if($hash eq $rowmd5){
					print "found $hash = $row\n";
					splice @HASHES, $c, 1;
					$cracked{$hash} = $row;
				}
				else{
					$row = lc $row;
					$rowmd5 = md5_hex $row;
					if($hash eq $rowmd5){
						print "found $hash = $row\n";
						splice @HASHES, $c, 1;
						$cracked{$hash} = $row;
					}
					else{
						$row = ucfirst lc $row;
						$rowmd5 = md5_hex $row;
						if($hash eq $rowmd5){
							print "found $hash = $row\n";
							splice @HASHES, $c, 1;
							$cracked{$hash} = $row;
						}
					}
				}
			}
			$c++;
		}
		last unless @HASHES;
	}
	close DICT;
	print "close $dictfile\n";
	last unless @HASHES;
}

print "\n\nresult\n----------------\n";

for my $md5 (keys %cracked){
	print "$md5 = $cracked{$md5}\n";
}
print "\n";
for my $md5 (@HASHES){
	print "$md5 not found\n";
}


1;
