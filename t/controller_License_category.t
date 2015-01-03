use strict;
use warnings;
use Test::More;


use Catalyst::Test 'cashregister';
use cashregister::Controller::License_category;

ok( request('/license_category')->is_success, 'Request should succeed' );
done_testing();
