package Slim::DataStores::DBI::Contributor;

# $Id$

use strict;
use base 'Slim::DataStores::DBI::DataModel';

{
	my $class = __PACKAGE__;

	$class->table('contributors');
	$class->columns(Essential => qw/id name namesort/);
	$class->columns(Stringify => qw/name/);
}

our @fields = qw(contributor artist composer conductor band);

tie our %_cache, 'Tie::Cache::LRU', 5000;

sub contributorFields {
	return \@fields;
}

sub searchName {
	my $class   = shift;
	my $pattern = shift;

	s/\*/%/g for @$pattern;

	my %where   = ( namesort => $pattern, );
	my $findKey = join(':', @$pattern);

	$_cache{$findKey} ||= [ $class->searchPattern('contributors', \%where, ['namesort']) ];

	return wantarray ? @{$_cache{$findKey}} : $_cache{$findKey}->[0];
}

1;

__END__


# Local Variables:
# tab-width:4
# indent-tabs-mode:t
# End:
