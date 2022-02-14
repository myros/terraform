package main

import data.validator.gcp.lib as lib

deny[{"msg": msg, "details": {"missing_tags": missing}}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	asset := input.asset

	asset.asset_type == params.types[_]

	resource_data := asset.resource.data

	provided := {label | label := resource_data.tags.items[_]}
	required := {label | label := params.required_tags[_]}

	missing := required - provided

	count(missing) != 0

	msg := sprintf("you must provide tags: %v", [missing])
}

in_list(required, tag) = missing {
	trace(sprintf("Tags: ", [tag]))
	not required[tag]

	missing := required[tag]
}
