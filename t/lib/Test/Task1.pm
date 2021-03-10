package Test::Task1;

use Mojo::Base 'Minion::Job', -signatures;
use Role::Tiny::With 'with';

sub enqueue_defaults { +{priority => -100, queue => 'special'} }

sub run ($self, @args) {
  $self->finish(sum => $args[0] + $args[1]);
}

with 'Minion::Job::Role::EnqueueDefaults';

1;
