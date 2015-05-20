use strict;
use warnings;

use Curso;

my $app = Curso->apply_default_middlewares(Curso->psgi_app);
$app;

