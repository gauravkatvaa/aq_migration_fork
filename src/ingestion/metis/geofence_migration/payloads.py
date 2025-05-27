import json
from urllib.parse import urlencode
from config import  *
from datetime import datetime



def rule_engine_payload(row, result_email, usernameID ):
    """
    row : input dataframe
    result_email : email id
    usernameID : user id
    return : pay load

    """

    payload = {
    "rule_name" : row["Rulename"],
    "account_id":  row["Account_ID"],
    "rule_category_id" : rule_category_id,
    "user_id" : usernameID,
    "rule_erval_unit" : rule_erval_unit,
    "rule_erval" : 30,
    "start_time" : geofenceRuleEngineStartDateTime,
    "rule_description" : rule_description,
    "imsi_from" :   row["Tag_ID"] ,
    "imsi_to" : "",
    "all_devices" : all_devices,
    "default_condition_id" : default_condition_id,
    "parameter_id": parameter_id,
    "comparator_id" : comparator_id,
    "condition_value" : row["Zone_ID"],
    "condition_id" : condition_id,
    "occurrence_count" : occurrence_count,
    "erval_unit" :erval_unit,
    "erval_value" : erval_value,
    "action_type_id" : action_type_id,
    "action_email_id" : result_email,
    "action_contact_number" : "",
    "changed_service_plane_id" : changed_service_plane_id,
    "changed_coverage_id" : changed_coverage_id,
    "state_change" : "",
    "action_subject" : "",
    "action_description" : "",
    "device_plane_id" : "",
    "changed_device_plane_id" : changed_device_plane_id,
    "webhook_metadata" : "",
    "plan_to_id" : "",
    "state_from" : "",
    "state_to" : "",
    "rule_sub_category_id" : "",
    "trigger_imsi_from" : "",
    "languages" : "en",
    "addon_device_plane_id" : "",
    "tag_bit" : 1
    }
    print("rule_engine_payload---", payload)
    url_encoded_data = urlencode(payload)

    return url_encoded_data






def create_lbs_zonePayload(row):
    """
    row : input data frame row

    return : encoded payload
    """

    load  =  f""""radius": {float(row["radius"])}, "lat": {float(row["lat"])}, "long": {float(row["lng"])}"""""

    print(load)
    load = "[{" + load + "}]"

    print(load)

    payload = {
    "zoneName" : row["zoneName"],
    "zoneType" : "Placemarks-Circle Map",
    "accountId" : row["Account_ID"],
    "description": "zonecCreationForMigration123",
    "latlong" : load,
    "active" : 1 }

    print("--------------------",payload)

    # Convert JSON to x-www-form-urlencoded
    url_encoded_data = urlencode(payload)

    return f'{url_encoded_data}'


def bulk_assign_unassignPayload(row, entityIdslist):
    """
    row : input data frame
    entityIdslist : list of assets id from respective imsis's
    return payload

    """

    accountId = row["Account_ID"]
    entityIdslist = entityIdslist
    lst = []
    lst.append(row["Tag_ID"])
    tagIdslist =  lst
    payload = json.dumps({
        "entityType": TagEntityType,
        "entityIds": entityIdslist,
        "accountId": accountId,
        "tagIds": tagIdslist,
        "actionIdentifier": "assign"
    })

    return  payload


def createTagPayload(row ):

    """
    input row data frame
    return : payload

    """
    tagName= row["TagName"]
    TagDescrition = row["TagDescription"]
    accountID = row["Account_ID"]
    payload = {
        "name" : tagName,
        "colorCoding": colorCoding,
        "entityType" : TagEntityType,
        "description" : TagDescrition,
        "accountId" :   accountID
    }
    print(payload)
    url_encoded_data = urlencode(payload)
    print("TagPayload : ", url_encoded_data)

    return url_encoded_data