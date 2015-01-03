use strict;
use warnings;
use Test::More;


use Catalyst::Test 'cashregister';
use cashregister::Controller::License;

ok( request('/license')->is_success, 'Request should succeed' );
done_testing();
