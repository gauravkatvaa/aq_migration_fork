import requests
from config import  validate_api_user, api_details
import json
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


class api_call:
    token = ""

    def __init__(self):
        pass


    def auth_user(self):
        """
        Method to generate auth token
        :return: Auth token
        """
        token = ''
        data = {
            "username" : validate_api_user["username"],
            "password" : validate_api_user["password"]
        }
        #print(data["username"])
        header = {'Content-Type': 'application/json'}
        print(validate_api_user['validate_api_user_url'])

        try :

          response = requests.request("POST", validate_api_user['validate_api_user_url'], data = data, verify=False)

        except Exception as e:
            print(e)

        if response.status_code == 200:
            auth_resp = json.loads(response.content)

            token = auth_resp["token"]
            api_call.token = token
            #print(token)
        return token


    def createlbsZoneAPI(self, data, token):
        """
        Method to createlbsZone
        :param data: API payload data
        :param token : token
        :return: API Response code and payload
        """
        url = api_details["createLbszone"]

        header = {'Authorization': token, 'Content-Type': 'application/x-www-form-urlencoded'}

        status_code = 401
        retry = 2
        print(retry, url, header, data)
        retry = retry - 1
        response = requests.request("POST", url, headers=header, data=data, verify=False)
        print(response)
        try:
            status_code = response.status_code
            content = response.content
        except Exception as e:
            print("createlbsZoneAPI", e)

        if status_code == 401 and retry:
            header["Authorization"] = self.token = self.auth_user()
            print(retry, url, header, data)
            response = requests.request("POST", url, headers=header, data=data, verify=False)
            print(response)
            try:
                status_code = response.status_code
                content = response.content
            except Exception as e:
                print("createlbsZoneAPI", e)

        return status_code, content


    def createTag(self, data, token):
        """
        Method to call create tag
        :param :
        :param data: API payload data
        :param token : token
        :return: API Response code and payload
        """
        url = api_details["createTag"]

        header = {'Authorization': token, 'Content-Type': 'application/x-www-form-urlencoded'}

        status_code = 401
        retry = 2
        print(retry, url, header, data)
        retry = retry - 1
        response = requests.request("POST", url, headers=header, data=data, verify=False)
        print(response)
        try:
            status_code = response.status_code
            content = response.content
        except Exception as e:
            print("createTag API", e)

        if status_code == 401 and retry:
            header["Authorization"] = self.token = self.auth_user()
            print(retry, url, header, data)
            response = requests.request("POST", url, headers=header, data=data, verify=False)
            print(response)
            try:
                status_code = response.status_code
                content = response.content
            except Exception as e:
                print("createTag API", e)

        return status_code, content

    def assignTag(self, data, token):
        """
        Method to assign tag
        :param : assignTag API url
        :param data: API payload data
        :param token : token
        :return: API Response code and payload
        """
        url = api_details["bulk-assign-unassign"]

        header = {'Authorization': token, 'Content-Type': 'application/json'}

        status_code = 401
        retry = 2
        print(retry, url, header, data)
        retry = retry - 1
        response = requests.request("PUT", url, headers=header, data=data, verify=False)
        print(response)
        try:
            status_code = response.status_code
            content = response.content
        except Exception as e:
            print("createTag API", e)

        if status_code == 401 and retry:
            header["Authorization"] = self.token = self.auth_user()
            print(retry, url, header, data)
            response = requests.request("PUT", url, headers=header, data=data, verify=False)
            print(response)
            try:
                status_code = response.status_code
                content = response.content
            except Exception as e:
                print("createTag API", e)

        return status_code, content

    def createRule(self, data, token):
        """
        Method to create rule
        :param : create rule
        :param data: API payload data
        :param token : token
        :return: API Response code and payload
        """
        url = api_details["addRule"]

        header = {'Authorization': token, 'Content-Type': 'application/x-www-form-urlencoded'}

        status_code = 401
        retry = 2
        print(retry, url, header, data)
        retry = retry - 1
        response = requests.request("POST", url, headers=header, data=data, verify=False)
        print(response)
        try:
            status_code = response.status_code
            content = response.content
        except Exception as e:
            print("create Rule API", e)

        if status_code == 401 and retry:
            header["Authorization"] = self.token = self.auth_user()
            print(retry, url, header, data)
            response = requests.request("POST", url, headers=header, data=data, verify=False)
            print(response)
            try:
                status_code = response.status_code
                content = response.content
            except Exception as e:
                print("create Rule API", e)

        return status_code, content







