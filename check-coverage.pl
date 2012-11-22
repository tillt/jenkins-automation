#!/usr/bin/perl

# Gcov coverage checker with "should never happen" exclusion
# Copyright (C) 2012  Matthew Skala
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Matthew Skala
# http://ansuz.sooke.bc.ca/
# mskala@ansuz.sooke.bc.ca


# this script is deprecated! Please use GCOVR!

$snherror=0;

$longest=5;
foreach $fn (@ARGV) {
  $longest=length($fn) if length($fn)>$longest;
}

$totshouldexec=0;
$totshouldntexec=0;
$totgoodexec=0;
$totbadexec=0;

foreach $fn (@ARGV) {
  open(GC,$fn);
  $shouldexec=0;
  $shouldntexec=0;
  $goodexec=0;
  $badexec=0;
  while (<GC>) {
    chomp;
    $should=1;
    $should=0 if m!/\*\s*SNH\s*\*/!;
    $should=0 if m!//\s*SNH\s*$!;
    if (/^\s*\d+:\s*\d+:/) {
      if ($should) {
        $shouldexec++;
        $goodexec++;
      } else {
        $shouldntexec++;
        $badexec++;
      }
    } elsif (/^\s*#####:\s*\d+:/) {
      if ($should) {
        $shouldexec++;
      } else {
        $shouldntexec++;
      }
    }
  }
  if ($shouldexec==0) {
    $goodexecp=1;
    $shouldexecp=1;
  } else {
    $goodexecp=$goodexec;
    $shouldexecp=$shouldexec;
  }
  if ($badexec>0) {
    $snherror=1;
    printf "%*s: %6d/%6d (%5.01f%%) + %6d/%6d (%5.01f%%) SNH\n",
      $longest,$fn,
      $goodexec,$shouldexec,100*$goodexecp/$shouldexecp,
      $badexec,$shouldntexec,100*$badexec/$shouldntexec;
  } else {
    $snherror=1 if $goodexec!=$shouldexec;
    printf "%*s: %6d/%6d (%5.01f%%)\n",
      $longest,$fn,
      $goodexec,$shouldexec,100*$goodexecp/$shouldexecp;
  }
  $totshouldexec+=$shouldexec;
  $totshouldntexec+=$shouldntexec;
  $totgoodexec+=$goodexec;
  $totbadexec+=$badexec;
  close(GC);
}

if ($totshouldexec==0) {
  $totgoodexecp=1;
  $totshouldexecp=1;
  $snherror=1;
} else {
  $totgoodexecp=$totgoodexec;
  $totshouldexecp=$totshouldexec;
}
if ($totbadexec>0) {
  printf "\n%*s: %6d/%6d (%5.01f%%) + %6d/%6d (%5.01f%%) SNH\n\n",
    $longest,'TOTAL',
    $totgoodexec,$totshouldexec,100*$totgoodexecp/$totshouldexecp,
    $totbadexec,$totshouldntexec,100*$totbadexec/$totshouldntexec;
} else {
  printf "\n%*s: %6d/%6d (%5.01f%%)\n\n",
    $longest,'TOTAL',
    $totgoodexec,$totshouldexec,100*$totgoodexecp/$totshouldexecp;
}
exit $snherror;
