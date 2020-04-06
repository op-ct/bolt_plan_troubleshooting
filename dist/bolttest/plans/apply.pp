# A plan to test how localhost `local`
#
# @usage:
#    bolt plan run bolttest::apply
#
#
#
#
plan bolttest::apply(
  TargetSpec $targets = get_targets('localhost'),
  String[1] $project_dir = system::env('PWD')
){

  # Add a new Target to a 'local' transport inventory group :
  $named_local_target = Target.new( 'name' => 'named_local_target' )
  $named_local_target.add_to_group( 'named_local_targets' )

  $both_targets = [$targets[0], $named_local_target]

  $both_targets.each |$target| {
    out::message( "\n==== target '${target}'" )

    run_command(
      "printf '${target.vars['content']}\n' > ${project_dir}/content.${target.name}.run_command.txt",
      $target,
      'Test run_command()',
      '_catch_errors' => false
    )

    run_task(
      'bolttest::write_file',
      $target,
      'Test run_task()',
      'file'          => "${project_dir}/content.${target.name}.run_task.txt",
      'content'       => "${target.vars['content']}\n",
      '_catch_errors' => false
    )

    apply(
      $target,
      '_description' => 'Test apply()',
      '_noop'        => false,
      _catch_errors  => false
    ){
      file{ "$project_dir/content.${target.name}.apply.txt": content => "${target.vars['content']}\n" }
    }
  }
}
