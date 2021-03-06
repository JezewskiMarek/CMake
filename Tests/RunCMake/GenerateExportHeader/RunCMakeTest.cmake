include(RunCMake)

function(run_GEH)
  # Use a single build tree for a few tests without cleaning.
  set(RunCMake_TEST_BINARY_DIR ${RunCMake_BINARY_DIR}/GEH-build)
  set(RunCMake_TEST_NO_CLEAN 1)
  if(RunCMake_GENERATOR MATCHES "Make|Ninja")
    set(RunCMake_TEST_OPTIONS -DCMAKE_BUILD_TYPE=Debug)
  endif()
  file(REMOVE_RECURSE "${RunCMake_TEST_BINARY_DIR}")
  file(MAKE_DIRECTORY "${RunCMake_TEST_BINARY_DIR}")
  run_cmake(GEH)
  run_cmake_command(GEH-build ${CMAKE_COMMAND} --build . --config Debug)
  run_cmake_command(GEH-run ${RunCMake_TEST_BINARY_DIR}/GenerateExportHeader)

  file(STRINGS "${RunCMake_TEST_BINARY_DIR}/failure_test_targets"
    failure_test_targets)

  foreach(failure_test_target ${failure_test_targets})
    run_cmake_command(GEH-link-error ${CMAKE_COMMAND}
      --build .
      --config Debug
      --target ${failure_test_target})
  endforeach()
endfunction()

run_GEH()
