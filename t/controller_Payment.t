use strict;
use warnings;
use Test::More;


use Catalyst::Test 'cashregister';
use cashregister::Controller::Payment;

ok( request('/payment')->is_success, 'Request should succeed' );
done_testing();
