package main

import data.validator.gcp.lib as lib

# importing the test data
import data.test.fixtures.cors_presence.assets.invalid as invalid_assets
import data.test.fixtures.cors_presence.assets.valid as valid_assets

# importing test constraints
import data.test.fixtures.cors_presence.constraints.disabled as disabled_constraint
import data.test.fixtures.cors_presence.constraints.invalid as invalid_constraint
import data.test.fixtures.cors_presence.constraints.valid as valid_constraint

test_cors_presence_valid_violations {
	constraints := [valid_constraint]
	violations := find_cors_violations with data.resources as valid_assets
		 with data.test_constraints as constraints

	trace(sprintf("Violations: %v", [violations]))
	count(violations) == 0
}

test_cors_presence_invalid_violations {
	constraints := [invalid_constraint]

	violations := find_cors_violations with data.resources as invalid_assets
		 with data.test_constraints as constraints

	trace(sprintf("Violations: %v", [count(violations)]))
	count(violations) == 1
}

# data not valid but policy check is disabled
test_cors_presence_disabled_violations {
	constraints := [disabled_constraint]

	violations := find_cors_violations with data.resources as invalid_assets
		 with data.test_constraints as constraints

	trace(sprintf("Violations: %v", [violations]))
	count(violations) == 0
}

# ===========================================================

find_cors_violations[violations] {
	resources := data.resources[_]
	constraint := data.test_constraints[_]

	# trace(sprintf("Data: %v", [resources.resource.data]))
	list_of_violations := deny with input.asset as resources
		 with input.constraint as constraint

	violations := list_of_violations[_]
}
