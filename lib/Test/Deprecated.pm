#
# $Id$
#

=head1 NAME

Test::Deprecated - test deprecation in phases

=head2 SYNOPSIS

  use Test::More tests => 2;
  use Test::Deprecated;
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

=head1 DESCRIPTION

Sometimes in the life a module it becomes necessary to remove old
functionality, either because it has been supplanted by something new or
because it's continued existence hinders growth. In such situations, it is
considered polite to deprecate functionality over several releases:

=over 4

=item * Phase 1

implement the new functionality (if it does not already exist) and document
that the old functionality will be deprecated in the future.

=item * Phase 2

deprecate the old functionality, causing warnings to be emitted when it is
used.

=item * Phase 3

require that the funtionality be specifically requested (i.e. via a custom
import tag or for OO modules via a specialized constructor) and continue to
emit deprecation warnings.

=item * Phase 4

remove the old functionality.

=back

The time scale that these phases fit into differs from project to project,
but the general idea remains the same.

Using Perl's C<warnings> pragma, the deprecation warnings may be suppressed:

  {
    no warnings 'deprecated':
    Foo::deprecated_function(...);
  }

Test::Deprecated helps ensure that the requirements of each phase are met.
Specifically, it allows you to check:

=over 4

=item *

that a function is exported and/or accessible as a method (phase 1)

=item *

that a function is exported and/or accessible as a method but produces
warnings when used unless specifically told not to (phase 2).

=item *

that a function or method is not available by default and produces warnings
when used unless specifically told not to (phase 3)

=item *

that a function or method is not available at all (phase 4)

=back

=head1 BEST PRACTICES

These practices represent the way that I deprecate functionality in a
module. If you follow these practices, this module will allow you to test
all of the phases of deprecation described above. You are of course free to
skip any of the phases if you wish. If you do things a little differently,
please read L<"Alternate Deprecation Policies">.

=head2 Coding for each phase

=over 4

=item * Phase 1

Add the new functionality to the module.

=item * Phase 2

In the old function, use the warnings pragma like this:

  use warnings;
  ...
  sub bar { ... }
  sub foo {
    warnings::warnif('deprecated', 'foo is deprecated ' .
                     '(use bar instead)');
    ...                    
  }

If you'd rather not use the B<deprecated> warnings category, use
C<warnings::register> to create a warning category named for your package:

  package Foo;
  use warnings;
  use warnings::register;
  sub bar { ... }
  sub foo {
      warnings::warnif('foo is deprecated...');
      ...
  }

Callers of the deprecated functionality may disable the warnings like this:

  { no warnings 'deprecated'; Foo::foo() }
  
Or if you've chosen to use warnings::register:

  { no warnings 'Foo'; Foo::foo() }

=item * Phase 3

Phase 3 will differ based upon the nature of the deprecated functionality:

=over 4

=item * a function exported by default

Stop exporting the function by default. Require that a custom import tag,
like C<:deprecated> be used to bring in the functionality.

=item * a function not exported by default

This is the trickiest one to test. Ideally you want to only the function to
be imported via the custom import tag, but if you are using C<Exporter>, the
function must somehow end up in C<@EXPORT_OK>, which means that it can also
be imported using it's explicit name. If a caller has always imported the
function using it's explicit name, this makes phase 3 no different from
phase 2.

=item * an object method

In your constructor, allow the caller to specify that they will be
using the deprecated functionality and store that fact in an instance
variable. In the method, check the state of the instance variable. If it
indicates that the deprecated functionality is to be available, proceed as
in phase 2. If not, throw an exception.

=back

=item * Phase 4

=back

=head2 Testing for each phase

=over 4

=item * Phase 1

=item * Phase 2

=item * Phase 3

=item * Phase 4

=back

=head1 TODO

=head2 Alternate Deprecation Policies

I would like to support multiple deprecation policies. Right now this module
works very well if you deprecate functionality as I do, but there are always
another ways to do it. I think the best way to do this would be to put the
current checks into a subclass (say Test::Deprecated::Base) and allow people
to define other policies by creating an alternate subclass.

If you'd like to see this module move in that direction, please let me know.

=head1 COPYRIGHT

Copyright (c) 2005 James FitzGibbon.  All Rights Reserved.

This module is free software.  You may use and/or modify it under the
same terms as perl itself.

=cut

#
# EOF
