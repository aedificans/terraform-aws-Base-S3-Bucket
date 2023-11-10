locals {
  _formatting = {
    env_display      = var.environment == null ? "" : title(var.environment.name)
    env_resource     = var.environment == null ? "" : var.environment.abbreviation
    network_display  = var.tagging.network == null ? "" : title(var.tagging.network)
    network_resource = var.tagging.network == null ? "" : replace(var.tagging.network, "/[_ ]/", "-")
    service_display  = title(var.naming.display)
    service_resource = coalesce(var.naming.resource, replace(var.naming.display, "/[ ]/", "-"))
  }
  naming = {
    display  = trimsuffix(trimsuffix("${local._formatting.service_display} ${local._formatting.env_display} ${title(local._formatting.network_display)}", " "), " ")
    iam      = replace("${local._formatting.service_display}${local._formatting.env_display}${local._formatting.network_display}", "/[ _-]/", "")
    resource = lower(trimsuffix(trimsuffix("${local._formatting.service_resource}-${local._formatting.env_resource}-${local._formatting.network_resource}", "-"), "-"))
  }
  tags = merge(
    var.tagging.additional_tags,
    var.environment == null ? {} : tomap({ "${var.tagging.tag_key_prefix}:environment" = var.environment.name }),
    var.tagging.network == null ? {} : tomap({ "${var.tagging.tag_key_prefix}:network" = var.tagging.network }),
    tomap({
      "${var.tagging.tag_key_prefix}:organization"    = var.tagging.organization
      "${var.tagging.tag_key_prefix}:resource:owner"  = var.tagging.owner
      "${var.tagging.tag_key_prefix}:service:name"    = coalesce(var.tagging.service_name, var.naming.display)
      "${var.tagging.tag_key_prefix}:service:pattern" = var.tagging.service_pattern
    })
  )
}
