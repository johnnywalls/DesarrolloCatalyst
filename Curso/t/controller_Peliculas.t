use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Curso';
use Curso::Controller::Peliculas;

ok( request('/peliculas')->is_success, 'Request should succeed' );
done_testing();
