def _time_time(_t):
    import dateparser
    import time
    d = dateparser.parse(_t)
    return time.mktime(d.timetuple())

_DATE_MODULE = {
    'Time': _time_time,
}