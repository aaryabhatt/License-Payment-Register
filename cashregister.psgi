use strict;
use warnings;

use cashregister;

my $app = cashregister->apply_default_middlewares(cashregister->psgi_app);
$app;

