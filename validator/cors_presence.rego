package main

import data.validator.gcp.lib as lib

# https://play.openpolicyagent.org/p/ouThfo6Qrp (with enabled)
# v2: https://play.openpolicyagent.org/p/FJNhu7LkSh

deny[{"msg": msg, "details": {"missing_cors": missing}}] {
	# an item is in the violation if...
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)

	# check rule enabled
	not lib.get_default(params, "disabled", "False") == true # policy is not disabled

	asset := input.asset

	is_valid_type(params.resource_types_to_scan, asset.asset_type) # AND is valid (allowed) resource type

	resource_data := asset.resource.data

	not lib.has_field(resource_data, "cors") # AND resource_data does not have field CORS

	missing := asset.name
	msg := sprintf("you must provide cors for a bucket: %v", [asset.name])
}

is_valid_type(to_scan, asset_type) = valid { # item is valid type if 
	valid := asset_type == to_scan[_]
}

is_enabled(params) {
	lib.has_field(params, "enabled")
	params.enabled
}

any_missing_field(input_data, field) {
	# some i
	# arr[i]
	not input_data.field
}
