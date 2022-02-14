# https://cloud.google.com/blog/products/identity-security/protecting-your-gcp-infrastructure-with-forseti-config-validator-part-three-writing-your-own-policy

# https://play.openpolicyagent.org/p/jBBcYB6Pa1
package templates.gcp.GCPAllowedResourceTypesConstraintV1

import data.validator.gcp.lib as lib

#Importing the test data
import data.test.fixtures.allowed_resource_types.assets as fixture_assets

# Importing the test constraints
import data.test.fixtures.allowed_resource_types.constraints.basic as fixture_constraint_basic

# Find all violations on our test cases
find_all_violations[violation] {
	resources := data.resources[_]
	constraint := data.test_constraints[_]
	issues := deny with input.asset as resources
		 with input.constraint as constraint

	violation := issues[_]
}

basic_violations[violation] {
	constraints := [fixture_constraint_basic]
	violations := find_all_violations with data.resources as fixture_assets
		 with data.test_constraints as constraints

	violation := violations[_]
}

test_resource_types_basic_violations {
	violations := basic_violations

	# trace(sprintf("Violation %v"), [v])

	trace(sprintf("Violations: %v", [count(violations)]))
	count(violations) == 6
}
