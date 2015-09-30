use strict;
use warnings;

# Las siguientes tres lineas para ejecutar sin "instalar" la aplicación
use FindBin qw($Bin);
use Path::Class;
use lib dir($Bin, 'lib')->stringify;

use Curso;

my $app = Curso->apply_default_middlewares(Curso->psgi_app);
$app;

