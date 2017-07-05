# encoding=utf-8

import time


class VZUtilTime:

    @staticmethod
    def get_current_time_str(time_formatted):
        '''
        Get current time and return a string time
        :param time_formatted: Like 2017-07-04 12:30:59 , its totally time formatted is %Y-%m-%d %H:%M:%S
        :return: the time string
        '''
        return time.strftime(time_formatted, VZUtilTime.get_current_localtime())

    @staticmethod
    def get_current_localtime():
        return time.localtime(time.time())

    @staticmethod
    def get_localtime_by_timestamp(timestamp_str):
        return time.localtime(timestamp_str)

    @staticmethod
    def get_current_timestamp():
        return time.time()

    @staticmethod
    def get_current_timestamp_without_float():
        return int(time.time())


