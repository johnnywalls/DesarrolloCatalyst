use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Curso';
use Curso::Controller::LeccionTT;

ok( request('/lecciontt')->is_success, 'Request should succeed' );
done_testing();
