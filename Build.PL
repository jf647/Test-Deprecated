#
# $Id$
#

use Module::Build;

Module::Build->new(

    module_name        => 'Test::Deprecated',
    dist_version_from  => 'lib/Test/Deprecated.pm',
    license            => 'perl',
    create_makefile_pl => 'traditional',
    create_readme      => 1,
    requires => {
        Test::Warn => 0,
    },
    build_requires => {
        Test::More          => 0,
        Test::Exception     => 0,
        Test::Pod           => 0,
        Test::Pod::Coverage => 0,
        Test::NoBreakpoints => 0,
    },

)->create_build_script;

#
# EOF
