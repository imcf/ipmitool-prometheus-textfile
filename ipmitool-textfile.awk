#!/usr/bin/awk -f

#
# Converts output of `ipmitool sensor` to prometheus format.
#
# With GNU awk:
#   ipmitool sensor | ./ipmitool > ipmitool.prom
#
# With BSD awk:
#   ipmitool sensor | awk -f ./ipmitool > ipmitool.prom
#

function export(values, name) {
	if (values["metric_count"] < 1) {
		return
	}
	delete values["metric_count"]

	printf("# HELP %s%s %s sensor reading from ipmitool\n", namespace, name, help[name]);
	printf("# TYPE %s%s gauge\n", namespace, name);
	for (sensor in values) {
		printf("%s%s{sensor=\"%s\"} %f\n", namespace, name, sensor, values[sensor]);
	}
}

# Fields are Bar separated, with space padding.
BEGIN {
	FS = "[ ]*[|][ ]*";
	namespace = "node_ipmi_";

	# Friendly description of the type of sensor for HELP.
	help["temperature_celsius"] = "Temperature";
	help["volts"] = "Voltage";
	help["power_watts"] = "Power";
	help["speed_rpm"] = "Fan";
	help["status"] = "Chassis status";

	temperature_celsius["metric_count"] = 0;
	volts["metric_count"] = 0;
	power_watts["metric_count"] = 0;
	speed_rpm["metric_count"] = 0;
	status["metric_count"] = 0;
}

# Not a valid line.
{
	if (NF < 3) {
		next
	}
}

# $2 is value field.
$2 ~ /na/ {
	next
}

# $3 is type field.
$3 ~ /degrees C/ {
	temperature_celsius[$1] = $2;
	temperature_celsius["metric_count"]++;
}

$3 ~ /Volts/ {
	volts[$1] = $2;
	volts["metric_count"]++;
}

$3 ~ /Watts/ {
	power_watts[$1] = $2;
	power_watts["metric_count"]++;
}

$3 ~ /RPM/ {
	speed_rpm[$1] = $2;
	speed_rpm["metric_count"]++;
}

$3 ~ /discrete/ {
	status[$1] = sprintf("%d", substr($2,3,2));
	status["metric_count"]++;
}

END {
	export(temperature_celsius, "temperature_celsius");
	export(volts, "volts");
	export(power_watts, "power_watts");
	export(speed_rpm, "speed_rpm");
	export(status, "status");
}

