#!/bin/sh

. /lib/functions.sh
. ../netifd-proto.sh
init_proto "$@"

proto_zeroconf_init_config() {
	proto_config_add_string 'ipaddr:ipaddr'
	proto_config_add_string 'range:ipaddr'
}

proto_zeroconf_setup() {
	local config="$1"
	local iface="$2"

	local ipaddr
	local range
	json_get_vars ipaddr range

	proto_export "INTERFACE=$config"
	proto_export "LOGGING=syslog"
	proto_run_command "$config" /sbin/zcip \
		${ipaddr:+-r $ipaddr} \
		${range:+-l $range} \
		-f "$iface" \
		/lib/netifd/zeroconf.script
}

proto_zeroconf_teardown() {
	local interface="$1"
	proto_kill_command "$INTERFACE"
}

add_protocol zeroconf

