#!/usr/bin/perl
use DBI;

### set database credentials
my $driver   = "Pg";
my $database = "postgres";
my $dsn = "DBI:$driver:dbname=$database;host=dataport.pecanstreet.org;port=5434";
my $userid = "**********";
my $password = "********";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
or die $DBI::errstr;

print "Opened database successfully\n";
### set output file location and name
open OUTPUT, "> //home//ubuntu//data//2014-electricity-minute_data.txt";

my $print_header = 1;
my $ds_aref = get_datasets($dbh);
my @dataids = @{$ds_aref};

foreach my $ds (@dataids)
{
	my $query = data_query($ds);
        print $query;
	my $qh = $dbh -> prepare($query);
	$qh -> execute();
	
	### print the column header only on the first execution
	if($print_header)
 	{
		print OUTPUT join("|",@{$qh->{NAME}}),"\n";
		$print_header = 0;
	}
	
	while(my @row = $qh -> fetchrow_array())
	{
 		print OUTPUT join ("|",@row),"\n";
	}
	
 	$qh -> finish();
}

close OUTPUT;
$dbh -> disconnect();
exit();

sub get_datasets
{
	my $dbh = shift;
	my $query = data_set_query();
	my $qh = $dbh -> prepare($query);
	$qh -> execute();

	my @datasets;
	while(my @row = $qh -> fetchrow_array())
	{
		push(@datasets,$row[0]);
	}
	
	$qh -> finish();

	return \@datasets;
}

sub data_set_query()
{
	my $query = "
		select distinct dataid
		from university.metadata
	";
	
	return $query;
}

sub data_query
{
	my $ds = shift;
	my $query = "
		SELECT *
		  FROM university.electricity_egauge_minutes
		  WHERE localminute >= '2014-01-01 00:00:00'
			AND localminute < '2015-01-01 00:00:00'
			AND dataid = $ds
";

	return $query;
}
