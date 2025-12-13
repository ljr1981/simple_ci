note
	description: "Test application for SIMPLE_CI"
	author: "Larry Rix"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run the tests.
		do
			print ("Running SIMPLE_CI tests...%N%N")
			passed := 0
			failed := 0

			run_lib_tests

			print ("%N========================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Test Runners

	run_lib_tests
		do
			create lib_tests
			-- Config tests
			run_test (agent lib_tests.test_config_make, "test_config_make")
			-- Project tests
			run_test (agent lib_tests.test_project_make, "test_project_make")
			run_test (agent lib_tests.test_project_enabled, "test_project_enabled")
			-- Runner tests
			run_test (agent lib_tests.test_runner_make, "test_runner_make")
			-- Build result tests
			run_test (agent lib_tests.test_build_result_make, "test_build_result_make")
			run_test (agent lib_tests.test_build_result_success, "test_build_result_success")
			run_test (agent lib_tests.test_build_result_failure, "test_build_result_failure")
		end

feature {NONE} -- Implementation

	lib_tests: LIB_TESTS

	passed: INTEGER
	failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test and update counters.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				a_test.call (Void)
				print ("  PASS: " + a_name + "%N")
				passed := passed + 1
			end
		rescue
			print ("  FAIL: " + a_name + "%N")
			failed := failed + 1
			l_retried := True
			retry
		end

end
