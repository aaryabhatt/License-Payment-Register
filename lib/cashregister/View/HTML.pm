package cashregister::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

#__PACKAGE__->config(
#    TEMPLATE_EXTENSION => '.tt',
#    render_die => 1,
#);

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,

    CATALYST_VAR => 'c',
    TIMER        => 0,
    ENCODING     => 'utf-8',
    WRAPPER => 'wrapper.tt',

);

=head1 NAME

cashregister::View::HTML - TT View for cashregister

=head1 DESCRIPTION

TT View for cashregister.

=head1 SEE ALSO

L<cashregister>

=head1 AUTHOR

amit,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
