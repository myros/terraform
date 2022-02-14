package main

import data.url
import data.validator.gcp.lib as lib

# importing the test data
import data.test.fixtures.force_instance_tags.assets as fixture_assets

# importing test constraints
import data.test.fixtures.force_instance_tags.constraints.invalid as invalid_constraint
import data.test.fixtures.force_instance_tags.constraints.valid as valid_constraint

test_force_labels_valid_violations {
	constraints := [valid_constraint]
	violations := find_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	count(violations) == 0
}

test_force_labels_invalid_violations {
	constraints := [invalid_constraint]

	# trace(sprintf("Provided: %v", [constraints.params]))

	violations := find_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	count(violations) == 1
}

# ===========================================================

find_violations[violations] {
	resources := data.resources[_]
	constraint := data.test_constraints[_]

	list_of_violations := deny with input.asset as resources
		 with input.constraint as constraint

	violations := list_of_violations[_]
}
