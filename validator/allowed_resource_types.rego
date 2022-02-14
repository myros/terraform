package templates.gcp.GCPAllowedResourceTypesConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	lib.get_constraint_params(constraint, params)
	asset := input.asset

	# 1 == 2
	message := sprintf("%v is in violation.", [asset.name])
	metadata := {"resource": asset.name}
}
