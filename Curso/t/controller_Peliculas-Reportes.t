use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Curso';
use Curso::Controller::Peliculas::Reportes;

ok( request('/peliculas/reportes')->is_success, 'Request should succeed' );
done_testing();
