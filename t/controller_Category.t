use strict;
use warnings;
use Test::More;


use Catalyst::Test 'cashregister';
use cashregister::Controller::Category;

ok( request('/category')->is_success, 'Request should succeed' );
done_testing();
