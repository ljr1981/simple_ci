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

	test_config_add_step
			-- Test adding build step.
		note
			testing: "covers/{CI_CONFIG}.add_step"
		local
			config: CI_CONFIG
		do
			create config.make
			config.add_step ("compile", "ec -batch")
			assert_true ("has step", config.has_step ("compile"))
		end

feature -- Test: Project

	test_project_make
			-- Test CI project creation.
		note
			testing: "covers/{CI_PROJECT}.make"
		local
			project: CI_PROJECT
		do
			create project.make ("my_project")
			assert_strings_equal ("name", "my_project", project.name)
		end

	test_project_path
			-- Test project path setting.
		note
			testing: "covers/{CI_PROJECT}.path"
		local
			project: CI_PROJECT
		do
			create project.make ("test")
			project.set_path ("/d/prod/test")
			assert_strings_equal ("path", "/d/prod/test", project.path)
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

feature -- Test: Workflow

	test_workflow_make
			-- Test workflow creation.
		note
			testing: "covers/{CI_WORKFLOW}.make"
		local
			workflow: CI_WORKFLOW
		do
			create workflow.make ("build")
			assert_strings_equal ("name", "build", workflow.name)
		end

	test_workflow_add_job
			-- Test adding job to workflow.
		note
			testing: "covers/{CI_WORKFLOW}.add_job"
		local
			workflow: CI_WORKFLOW
		do
			create workflow.make ("test")
			workflow.add_job ("compile", "ec -batch")
			assert_true ("has job", workflow.has_job ("compile"))
		end

feature -- Test: Build Result

	test_build_result_success
			-- Test successful build result.
		note
			testing: "covers/{CI_BUILD_RESULT}.make_success"
		local
			result: CI_BUILD_RESULT
		do
			create result.make_success
			assert_true ("is success", result.is_success)
			assert_false ("no errors", result.has_errors)
		end

	test_build_result_failure
			-- Test failed build result.
		note
			testing: "covers/{CI_BUILD_RESULT}.make_failure"
		local
			result: CI_BUILD_RESULT
		do
			create result.make_failure ("Compilation error")
			assert_false ("is not success", result.is_success)
			assert_true ("has errors", result.has_errors)
		end

feature -- Test: Report

	test_report_make
			-- Test report creation.
		note
			testing: "covers/{CI_REPORT}.make"
		local
			report: CI_REPORT
		do
			create report.make
			assert_attached ("report created", report)
		end

	test_report_add_entry
			-- Test adding report entry.
		note
			testing: "covers/{CI_REPORT}.add_entry"
		local
			report: CI_REPORT
		do
			create report.make
			report.add_entry ("Build started")
			assert_false ("not empty", report.entries.is_empty)
		end

end
