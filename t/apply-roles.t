# -*- mode: perl -*-
use Role::Tiny;
use Mojo::Base -strict, -signatures;
use Mojo::File qw(curfile);
use Mojo::Loader qw(load_class);
use Mojo::Promise;
use Test::More;
use Minion;
use Minion::Job;
use lib 't/lib';

subtest 'Minion role' => sub {
  my $minion = new_ok 'Minion' => [SQLite => ':memory:'];
  $minion->with_roles('+EnqueueDefaults');
  is Role::Tiny::does_role($minion, 'Minion::Role::EnqueueDefaults'), 1, 'role composed';

  $minion = Minion->with_roles('Minion::Role::EnqueueDefaults')->new(SQLite => 'sqlite:memory');
  ok $minion, 'new object ok';
  is Role::Tiny::does_role($minion, 'Minion::Role::EnqueueDefaults'), 1, 'role composed';
};

subtest 'Job role' => sub {
  my @errors;
  Mojo::Promise->resolve->then(sub {
    my $job = Minion::Job->with_roles('+EnqueueDefaults');
  })->catch(sub ($e) { push @errors, $e })->wait;
  is @errors, 1, 'failed to compose';
  like $errors[0], qr/missing enqueue_defaults/, 'required method missing';
};

subtest 'Task1 composed' => sub {
  my $loaded = load_class 'Test::Task1';
  ok !$loaded;

  my $minion = new_ok 'Minion' => [SQLite => ':memory:'];
  my $job    = Test::Task1->new(minion => $minion);
  ok $job;
  is_deeply $job->enqueue_defaults, {priority => -100, queue => 'special'}, 'defaults';
};

done_testing
