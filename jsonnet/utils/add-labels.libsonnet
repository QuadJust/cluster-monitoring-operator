{
  local managedBy(o) =
    local name = o.metadata.name;
    // Some of the resources which are generated by jsonnet are moved under manifests/ and managed by CVO.
    if o.kind == 'CustomResourceDefinition' || (o.kind == 'Role' && name == 'cluster-monitoring-operator-alert-customization') || (o.kind == 'Deployment' && name == 'cluster-monitoring-operator') || (o.kind == 'ClusterRole' && std.setMember(name, ['cluster-monitoring-operator-namespaced', 'cluster-monitoring-operator'])) then
      'cluster-version-operator'
    else
      'cluster-monitoring-operator',

  addLabels(labels, o): {
    // ignore *List types. metav1.ListMeta does not include metadata.
    [k]: o[k] + if !std.endsWith(o[k].kind, 'List') then { metadata+: { labels+: labels { 'app.kubernetes.io/managed-by': managedBy(o[k]) } } } else {}
    for k in std.objectFields(o)
  },
}
