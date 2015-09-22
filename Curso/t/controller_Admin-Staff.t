use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Curso';
use Curso::Controller::Admin::Staff;

ok( request('/admin/staff')->is_success, 'Request should succeed' );
done_testing();
