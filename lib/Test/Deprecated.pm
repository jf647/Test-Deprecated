#
# $Id$
#

=head1 NAME

Test::Deprecated - test deprecation in phases

=head2 SYNOPSIS

  use Test::More tests => 2;
  use Test::Deprecated qw|:phase1|;
  use_ok('Foo');
  is_deprecated_ok('Foo', ['foo']);

=cut

package Test::Deprecated;

use strict;
use warnings;

our $VERSION = '0.10';

# keep require happy
1;


__END__


=head1 COPYRIGHT

Copyright (c) 2005 James FitzGibbon.  All Rights Reserved.

This module is free software.  You may use and/or modify it under the
same terms as perl itself.

=cut

#
# EOF
