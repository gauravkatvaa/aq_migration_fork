import logging
import os
from os.path import join

class logger_():
    def __init__(self, dir_path, log_file_name):
        self.dir_path = dir_path
        self.log_file_name = log_file_name

    def get_logger(self):
        file_path = join(self.dir_path, self.log_file_name)

        # print(log_file_base_path + log_file_name)
        aq_logger = logging.getLogger(self.log_file_name)
        aq_logger.setLevel(logging.DEBUG)
        file_handler = logging.FileHandler(file_path)
        if aq_logger.handlers:
            aq_logger.handlers = []


        formatter = logging.Formatter(
            '%(asctime)s - [%(levelname)s] - %(funcName)s - %(filename)s - %(lineno)d : %(message)s')


        file_handler.setFormatter(formatter)
        # Setting the threshold of aq_logger to DEBUG
        aq_logger.addHandler(file_handler)

        return aq_logger




"""

def get_logger(dir_path, log_file_name, debug = False):
    file_path = join(dir_path, log_file_name)

    # print(log_file_base_path + log_file_name)
    aq_logger = logging.getLogger(f'log_file_name')
    if debug == False:
        aq_logger.setLevel(logging.DEBUG)
    else :
        aq_logger.setLevel(logging.ERROR)
    file_handler = logging.FileHandler(file_path)

    formatter = logging.Formatter('%(asctime)s - %(levelname)s : %(message)s')

    file_handler.setFormatter(formatter)
    # Setting the threshold of aq_logger to DEBUG
    aq_logger.addHandler(file_handler)

    return aq_logger

"""