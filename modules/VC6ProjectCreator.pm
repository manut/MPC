package VC6ProjectCreator;

# ************************************************************
# Description   : A VC6 Project Creator
# Author        : Chad Elliott
# Create Date   : 3/14/2002
# ************************************************************

# ************************************************************
# Pragmas
# ************************************************************

use strict;

use WinVersionTranslator;
use ProjectCreator;

use vars qw(@ISA);
@ISA = qw(ProjectCreator);

# ************************************************************
# Subroutine Section
# ************************************************************

sub get_makefile_ext {
  #my($self) = shift;
  return '.mak';
}


sub compare_output {
  #my($self) = shift;
  return 1;
}


sub base_project_name {
  my($self) = shift;
  return $self->transform_file_name($self->project_name());
}


sub require_dependencies {
  my($self) = shift;

  ## Only write dependencies for non-static projects
  ## and static exe projects, unless the user wants the
  ## dependency combined static library.
  return ($self->get_static() == 0 || $self->exe_target() ||
          $self->dependency_combined_static_library());
}

sub dependency_is_filename {
  #my($self) = shift;
  return 0;
}


sub file_sorter {
  my($self)  = shift;
  my($left)  = shift;
  my($right) = shift;
  return lc($left) cmp lc($right);
}


sub crlf {
  my($self) = shift;
  return $self->windows_crlf();
}


sub fill_value {
  my($self)  = shift;
  my($name)  = shift;
  my($value) = undef;

  if ($name eq 'make_file_name') {
    $value = $self->base_project_name() . $self->get_makefile_ext();
  }
  elsif ($name eq 'win_version') {
    $value = $self->get_assignment('version');
    if (defined $value) {
      $value = WinVersionTranslator::translate($value);
    }
  }

  return $value;
}


sub project_file_name {
  my($self) = shift;
  return $self->get_modified_project_file_name($self->project_name(),
                                               '.dsp');
}


sub override_valid_component_extensions {
  my($self)  = shift;
  my($comp)  = shift;
  my($array) = undef;

  if ($comp eq 'source_files' && $self->get_language() eq 'cplusplus') {
    $array = ["\\.cpp", "\\.cxx", "\\.c"];
  }

  return $array;
}


sub override_exclude_component_extensions {
  my($self)  = shift;
  my($comp)  = shift;
  my($array) = undef;

  if ($comp eq 'source_files') {
    my(@exts) = ("_T\\.cpp", "_T\\.cxx");
    $array = \@exts;
  }

  return $array;
}


sub get_dll_exe_template_input_file {
  #my($self) = shift;
  return 'vc6dspdllexe';
}


sub get_lib_exe_template_input_file {
  #my($self) = shift;
  return 'vc6dsplibexe';
}


sub get_lib_template_input_file {
  #my($self) = shift;
  return 'vc6dsplib';
}


sub get_dll_template_input_file {
  #my($self) = shift;
  return 'vc6dspdll';
}


sub get_template {
  #my($self) = shift;
  return 'vc6dsp';
}


1;
