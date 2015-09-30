#!/usr/bin/env perl
use warnings;
use strict;

# 1) Para generar un init script:
# ./curso_gen_init_file_psgi.pl get_init_file > curso_ctl
#
# Si queremos activar al inicio del sistema operativo:
#
# 2) Copiar a directorio de sistema
# cp curso_ctl /etc/init.d/curso_prod  # (o el ambiente deseado)
#
# 3) Instalar en los runlevels requeridos
# update-rc.d curso_prod defaults

use Daemon::Control;
use FindBin qw($Bin);
use Path::Class;

my $app_home = dir($Bin, '..', '..')->stringify; # También se puede colocar manualmente

# Ruta a instalación base de perlbrew. Ajustar según sea necesario
my $perlbrew_root = '/home/jparedes/perl5/perlbrew';

# version de perl a utilizar con perlbrew
my $perlbrew_version = 'perl-5.20.3';

my $perlbrew_path = "$perlbrew_root/perls/$perlbrew_version";

# Ruta a ejecutable de perl
my $perl     = "$perlbrew_path/bin/perl";

# Para cargar configuración de perlbrew al inicio
my $init_code = <<BASH;
export PATH=$perlbrew_path/bin:/usr/local/bin:/usr/bin:/bin
BASH

# Nombre de la aplicación (mismo nombre que el módulo principal)
my $name     = 'Curso';
my $unix_name = lc($name);
$unix_name =~ s/::/_/;

# sufijo con archivo de configuración prioritario (ambiente) a cargar
my $local_suffix = 'prod';
$init_code .= "export ". uc($unix_name) ."_CONFIG_LOCAL_SUFFIX=$local_suffix" if $local_suffix;

# Puerto TCP, ajustar según sea necesario. También se podrían usar sockets UNIX, modificando
# los parámetros a utilizar con Daemon::Control (path)
my $port   = '127.0.0.1:5000';

# Archivo con identificación de proceso
my $pid_file = '/tmp/' . $unix_name . '_' . $local_suffix . '.pid';

# Otros parámetros
my $workers  = 1; # Ajustar según la carga esperada de transacciones y capacidad del equipo

# La aplicación se ejecuta con los privilegios de un usuario/grupo específicos,
# brindando mayor seguridad al no exponer cuentas de administración, como root, separándola
# también del usuario que ejecute el servidor web (www-data, típicamente), si está en el mismo equipo
my $user = 'jparedes';
my $group = 'jparedes';

# Ruta al script o programa (puede ser FastCGI, PSGI, etc)

# Usando 'starman'
#my $program  = "$perlbrew_path/bin/start_server --port $port -- starman --workers $workers $unix_name.psgi";
# Usando 'Starlet'
#my $program  = "$perlbrew_path/bin/start_server --port $port -- plackup -s Starlet --max-workers=$workers $unix_name.psgi";
# Usando 'Gazelle'
my $program  = "$perlbrew_path/bin/start_server --port $port -- plackup -s Gazelle --workers=$workers -E production -a $unix_name.psgi";

Daemon::Control->new({
  name        => $name,
  # Los siguientes son parámetros LSB (Linux Standard Base) usados para describir el servicio
  lsb_start   => '$nginx', # Si queremos indicar una dependencia del servicio de la aplicación
  lsb_stop    => '$nginx', # con el servidor web, en caso de que residan en el mismo equipo
  lsb_sdesc   => $name,
  lsb_desc    => $name,

  user        => $user,
  group       => $group,

  directory   => $app_home, # con esto, se hace 'cd' al directorio de la aplicación al iniciarla
  program     => "$perl $program", # ejecutar nuestro script de inicio con la versión deseada de perl

  pid_file    => $pid_file, # el archivo PID sirve para poder verificar y controlar el servicio posteriormente

  stderr_file => "/tmp/$unix_name.out", # En nuestro caso, es opcional que utilicemos la salida estándar
  stdout_file => "/tmp/$unix_name.out", # y error estándar, ya que también estamos usando Log4perl

  init_code   => $init_code, # el contenido de este parámetro se ejecutará en el script de inicio

  fork        => 2,
})->run;