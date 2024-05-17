from datadog import initialize, statsd
import random
import time
import os

ip = os.environ.get("DD_AGENT_HOST")
options = {
    'statsd_host':ip,
    'statsd_port':8125
}
# options = {
#     "statsd_socket_path": '/var/run/datadog/dsd.socket',
# }

initialize(**options)

types = ['gauge', 'increment', 'decrement', 'distribution', 'histogram']


def noValMetricCall(metric_type, tags_string):
    # concatentate the full argument of the metric to be submitted
    metric_arg = "'sc_sandbox.example_metric." + metric_type + "', tags=[" + tags_string + "]"
    eval('statsd.' + metric_type + "(" + metric_arg + ")")

def withValMetricCall(metric_type, tags_string, val):
    # concatentate the full argument of the metric to be submitted
    metric_arg = "'sc_sandbox.example_metric." + metric_type + "', " + str(val) + ", tags=[" + tags_string + "]"
    eval('statsd.' + metric_type + "(" + metric_arg + ")")

def submitMetric(metric_type, tags, value=0):
    # convert tags dict to string
    tags_string = ', '.join("'{!s}:{!s}'".format(key,val) for (key,val) in tags.items())
    # inc/dec do not accept a value parameter, all others require it
    noValMetricCall(metric_type, tags_string) if metric_type in ['increment', 'decrement'] else withValMetricCall(metric_type, tags_string, value)


while(1):
    # each metric type will be submitted at regular 5 second intervals with two different sets of tags
    success_tags = {'alert':'false', 'status_type':'success', 'lang':'python'}
    fail_tags = {'alert':'true', 'status_type':'failed', 'lang':'python'}
    # for metric types that accept a value
    # the "good" values will be )  0 <= val <=20
    # the "bad" values will be )  21 <= val <=40
    good_val = random.randint(0, 20)
    bad_val = random.randint(21, 40)
    for type in types:
        submitMetric(type, success_tags, good_val)
        submitMetric(type, fail_tags, bad_val)
    time.sleep(5)