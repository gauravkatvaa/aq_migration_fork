import logging
import os
from os.path import join

class logger_():
    """
    logging
    :param (constructor) : directory path
    :param (constructor) : log file name
    :return  logger with logging level

    """
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

        formatter = logging.Formatter('%(asctime)s - [%(levelname)s] - %(funcName)s - %(filename)s - %(lineno)d : %(message)s')

        file_handler.setFormatter(formatter)
        # Setting the threshold of aq_logger to DEBUG
        aq_logger.addHandler(file_handler)

        return aq_logger




