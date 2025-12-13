note
	description: "Tests for SIMPLE_CI"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"
	testing: "covers"

class
	LIB_TESTS

inherit
	TEST_SET_BASE

feature -- Test: Config

	test_config_make
			-- Test CI config creation.
		note
			testing: "covers/{CI_CONFIG}.make"
		local
			config: CI_CONFIG
		do
			create config.make
			assert_attached ("config created", config)
		end

feature -- Test: Project

	test_project_make
			-- Test CI project creation.
		note
			testing: "covers/{CI_PROJECT}.make"
		local
			project: CI_PROJECT
		do
			create project.make ("my_project", "/d/prod/my_project/my_project.ecf")
			assert_strings_equal ("name", "my_project", project.name)
			assert_strings_equal ("ecf_path", "/d/prod/my_project/my_project.ecf", project.ecf_path)
		end

	test_project_enabled
			-- Test project enable/disable.
		note
			testing: "covers/{CI_PROJECT}.is_enabled"
		local
			project: CI_PROJECT
		do
			create project.make ("test", "/d/prod/test/test.ecf")
			assert_true ("enabled by default", project.is_enabled)
			project.disable
			assert_false ("disabled", project.is_enabled)
			project.enable
			assert_true ("re-enabled", project.is_enabled)
		end

feature -- Test: Runner

	test_runner_make
			-- Test CI runner creation.
		note
			testing: "covers/{CI_RUNNER}.make"
		local
			runner: CI_RUNNER
		do
			create runner.make
			assert_attached ("runner created", runner)
		end

feature -- Test: Build Result

	test_build_result_make
			-- Test build result creation.
		note
			testing: "covers/{CI_BUILD_RESULT}.make"
		local
			l_result: CI_BUILD_RESULT
		do
			create l_result.make ("test_project", "test_target")
			assert_strings_equal ("project name", "test_project", l_result.project_name)
			assert_strings_equal ("target name", "test_target", l_result.target_name)
		end

	test_build_result_success
			-- Test successful build result.
		note
			testing: "covers/{CI_BUILD_RESULT}.set_success"
		local
			l_result: CI_BUILD_RESULT
		do
			create l_result.make ("test", "target")
			l_result.set_success
			assert_true ("is success", l_result.is_success)
		end

	test_build_result_failure
			-- Test failed build result.
		note
			testing: "covers/{CI_BUILD_RESULT}.set_failed"
		local
			l_result: CI_BUILD_RESULT
		do
			create l_result.make ("test", "target")
			l_result.set_failed ("Compilation error")
			assert_false ("is not success", l_result.is_success)
		end

end
