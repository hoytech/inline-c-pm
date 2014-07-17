# Some tests regarding 'const' qualifier.
# Here we use the ParseRegExp parser.

use strict;
use warnings;

use Test::More;

BEGIN {
  if (exists $ENV{PERL_INSTALL_ROOT}) {
  warn "\nIgnoring \$ENV{PERL_INSTALL_ROOT} in $0\n";
  delete $ENV{PERL_INSTALL_ROOT};
  }
  mkdir('_Inline_test', 0777) unless -e '_Inline_test';
}

use Inline C => Config =>
  USING => 'ParseRegExp',
  DIRECTORY => '_Inline_test';

use Inline C => <<'EOC';

char* ptr_to_const_param ( const char * c ) {
  return c;
}


char* const_ptr_to_param ( char * const c ) {
  return c;
}

const char* return_ptr_to_const( char* c ) {
  return (const char*) c;
}

char * const return_const_ptr ( char* c ) {
  return (char * const) c;
}

EOC


my %tests = (
  param_pointer_to_const     => \&ptr_to_const_param,
  param_const_pointer        => \&const_ptr_to_param,
  return_pointer_to_constant => \&return_ptr_to_const,
  return_const_pointer       => \&return_const_ptr,
);

foreach my $test_name ( keys %tests ) {
  my $rv = '';
  my $result = eval {
    $rv = $tests{$test_name}->("Testing 1 2 3\n");
    1;
  };
  ok( $result, "$test_name completed without throwing an exception." );
  is( $rv, "Testing 1 2 3\n", $test_name );
}

done_testing();




