use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Curso';
use Curso::Controller::Admin::Categoria;

ok( request('/admin/categoria')->is_success, 'Request should succeed' );
done_testing();
