# encoding=utf-8

import random
from Kernel.Utilities.VZUtilTime import VZUtilTime


class VZUtilCommon:

    @staticmethod
    def generate_session_id(ip_address):
        __timestamp = str(VZUtilTime.get_current_timestamp_without_float())
        __random_num = str(VZUtilCommon.get_random_number(1, 10000000))
        __session_id = __random_num + __timestamp + ip_address.replace('.', '')
        return __session_id

    @staticmethod
    def get_random_number(start_num, end_num):
        return random.randint(start_num, end_num)
