#!/usr/bin/perl
#
# Command-line Weather Report
# Stan Hammond - 2012 (Updated 2015)
#
# This Perl script queries Weather Underground for the current weather report for 
# a specified area and then parses the report extracting the pertinent information.
# That information is then displayed on the command-line.
# The 2015 update added the ability to modify the city and state in separate variables.
# Originally this needed to be modified in the URL variable.
# Also the update addressed an issue were, depending on the city/state you receive the report
# WU would use different naming for afternoon such as this afternoon or rest of day, etc.
#
# This script is a hack.  So improvements would be:
# 1. Using another weather service than Weather Underground (need uniformity to report)
# 2. Find a better way to get URL data than an external call to curl
# 

# Added the following change that makes changing the city and state easier
$city = "Bourne";
$state = "MA"; # Should be two letter abbreviation

$URL="http://rss.wunderground.com/auto/rss_full/$state/$city.xml?units=english";
@report = `curl -s "$URL"`;

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
@day = qw( Sunday Monday Tuesday Wednesday Thursday Friday Saturday );
$today = $day[$wday];
$nday = ++$wday;
$tomorrow = $day[$nday];

print "\nWeather conditions for $city, $state\n";

# Phrase the report and extract the relevant data
foreach $line (@report){
	chomp $line;
	$line =~ s/\<\!\[CDATA\[//g;
	$line =~ s/\&deg\;/°/g;
	if ($line =~ /\<lastBuildDate\>/){
		$line =~ s/\<lastBuildDate\>//g;
		$line =~ s/\<\/lastBuildDate\>//g;
		$line =~ s/  //g;
		print "As of $line\n";
	}
	if ($line =~ /\<description\>Te/){
		$line =~ s/\<description\>//g;
		$line =~ s/\]\]\>//g;
		$line =~ s/\</\|/g;
		$line =~ s/\t/ /g;
		$line =~ s/\(\s+/\(/g;
		@current = split(/\|/,$line);
		
		print "$current[3]\n"; #Current conditions
		print "$current[0]\n"; #Temperature
		print "$current[1]\n"; #Humidity
		print "$current[2]\n"; #Barometric Pressure
		print "$current[4]\n"; #Wind direction
		print "$current[5]\n"; #Wind speed
		
	}

# Following added to correct change in how "today's" forecast is listed
	if ((($line =~ $today) && ($line !~ /Night/)) || ($line =~ /This Afternoon/) || ($line =~ /Rest of Today/)){
		$line =~ s/\t/ /g;
		$Forecast1 = $line;
		$t = "1";
	}
	if (($line =~ /Tonight/) || ($line =~ $today) && ($line =~ /Night/)){
		$line =~ s/\t/ /g;
		$Forecast2 = $line;
	}
	if (($line =~ $tomorrow) && ($line !~ /Night/)){
		$line =~ s/\t/ /g;
		$Forecast3 = $line;
	}
	if (($line =~ $tomorrow) && ($line =~ /Night/)){
		$line =~ s/\t/ /g;
		$Forecast4 = $line;
	}
}

# Print the upcoming forecast, based on the time of day report was received
print "\nForecast:\n";
if ($t == "1"){
	print "$Forecast1\n";
	print "$Forecast2\n";
	print "$Forecast3\n";
}
else{
	print "$Forecast2\n";
	print "$Forecast3\n";
	print "$Forecast4\n";
}
print "\n";
